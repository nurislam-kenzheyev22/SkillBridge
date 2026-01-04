//
//  APIService.swift
//  SkillBridge
//
//  API endpoints and requests with Mock data support
//

import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let name: String
}

struct LoginResponse: Codable {
    let token: String
    let user: User
}

struct RoadmapRequest: Codable {
    let userId: String
}

class APIService: APIServiceProtocol {
    static let shared = APIService()
    private let networkService: NetworkServiceProtocol
    private let useMockData: Bool
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared, useMockData: Bool = false) {
        self.networkService = networkService
        self.useMockData = useMockData
    }
    
    // MARK: - Authentication
    func login(email: String, password: String) async throws -> LoginResponse {
        if useMockData {
            // Simulate network delay
            try await Task.sleep(nanoseconds: 200_000_000) // 1 second
            return LoginResponse(token: "mock_token", user: MockData.mockUser)
        }
        
        let request = LoginRequest(email: email, password: password)
        return try await networkService.request(
            endpoint: "/api/auth/login",
            method: .post,
            body: request
        )
    }
    
    func register(email: String, password: String, name: String) async throws -> LoginResponse {
        if useMockData {
            try await Task.sleep(nanoseconds: 200_000_000)
            let user = User(id: UUID(), email: email, name: name, role: .student)
            return LoginResponse(token: "mock_token", user: user)
        }
        
        let request = RegisterRequest(email: email, password: password, name: name)
        return try await networkService.request(
            endpoint: "/api/auth/register",
            method: .post,
            body: request
        )
    }
    
    // MARK: - User
    func getCurrentUser() async throws -> User {
        if useMockData {
            try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
            return MockData.mockUser
        }
        
        return try await networkService.request(
            endpoint: "/api/users/me",
            method: .get
        )
    }
    
    // MARK: - Curriculum
    func uploadCurriculum(fileURL: URL) async throws -> Curriculum {
        if useMockData {
            try await Task.sleep(nanoseconds: 500_000_000) // 2 seconds
            return Curriculum(
                id: UUID(),
                title: "IITU Software Engineering Curriculum",
                status: .completed,
                source: .upload,
                modules: [],
                createdAt: Date()
            )
        }
        
        return try await networkService.request(
            endpoint: "/api/curricula/upload",
            method: .post
        )
    }
    
    // MARK: - Gap Report
    func getGapReport(userId: UUID) async throws -> GapReport {
        if useMockData {
            try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
            return MockData.mockGapReport(userId: userId)
        }
        
        return try await networkService.request(
            endpoint: "/api/gap-reports/\(userId)",
            method: .get
        )
    }
    
    // MARK: - Roadmap
    func generateRoadmap(userId: UUID) async throws -> Roadmap {
        if useMockData {
            try await Task.sleep(nanoseconds: 500_000_000) // 2 seconds
            return MockData.mockRoadmap(userId: userId)
        }
        
        let request = RoadmapRequest(userId: userId.uuidString)
        return try await networkService.request(
            endpoint: "/api/roadmaps/generate",
            method: .post,
            body: request
        )
    }
    
    // MARK: - Courses
    func getCourses() async throws -> [Course] {
        if useMockData {
            try await Task.sleep(nanoseconds: 200_000_000) // 1 second
            return MockData.mockCourses
        }
        
        return try await networkService.request(
            endpoint: "/api/courses",
            method: .get
        )
    }
}
