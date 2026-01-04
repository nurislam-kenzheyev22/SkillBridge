//
//  NetworkService.swift
//  SkillBridge
//
//  Network layer for API calls - MVVM Architecture
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case decodingError
    case unauthorized
    case serverError(Int)
    case noConnection
    
    var localizedDescription: String {
        switch self {
        case .noConnection:
            return "No internet connection"
        case .unauthorized:
            return "Session expired. Please login again"
        default:
            return "Something went wrong"
        }
    }
}

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod
    ) async throws -> T
    
    func request<T: Decodable, B: Encodable>(
        endpoint: String,
        method: HTTPMethod,
        body: B
    ) async throws -> T
}

class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    private let session: URLSession
    private let baseURL: String
    
    private init() {
        self.session = URLSession.shared
        self.baseURL = AppConstants.baseURL
    }
    
    // Request without body
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get
    ) async throws -> T {
        return try await performRequest(endpoint: endpoint, method: method, bodyData: nil)
    }
    
    // Request with body
    func request<T: Decodable, B: Encodable>(
        endpoint: String,
        method: HTTPMethod,
        body: B
    ) async throws -> T {
        let bodyData = try JSONEncoder().encode(body)
        return try await performRequest(endpoint: endpoint, method: method, bodyData: bodyData)
    }
    
    // Internal implementation
    private func performRequest<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        bodyData: Data?
    ) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add authorization token if available
        if let token = KeychainManager.shared.retrieve(forKey: AppConstants.KeychainKeys.accessToken) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Add body if present
        request.httpBody = bodyData
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if httpResponse.statusCode == 401 {
                    throw NetworkError.unauthorized
                }
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            // Custom date decoding - formatter created inside closure to avoid non-sendable warning
            decoder.dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                if let date = formatter.date(from: dateString) {
                    return date
                }
                formatter.formatOptions = [.withInternetDateTime]
                return formatter.date(from: dateString) ?? Date()
            }
            return try decoder.decode(T.self, from: data)
            
        } catch let error as DecodingError {
            print("Decoding error: \(error)")
            throw NetworkError.decodingError
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.noConnection
        }
    }
}
