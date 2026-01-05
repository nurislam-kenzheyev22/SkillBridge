//
//  AppError.swift
//  SkillBridge
//
//  Centralized error handling following Clean Code principles
//

import Foundation

/// Unified error type for the entire application
/// Follows Error Handling best practices
enum AppError: LocalizedError {
    // MARK: - Network Errors
    case networkError(NetworkError)
    case invalidResponse
    case decodingError(String)
    case unauthorized
    case serverError(Int, String?)
    
    // MARK: - Validation Errors
    case validationError(String)
    case invalidInput(String)
    
    // MARK: - Business Logic Errors
    case userNotFound
    case curriculumNotFound
    case roadmapNotFound
    case skillNotFound
    
    // MARK: - UI Errors
    case fileUploadFailed(String)
    case imageProcessingFailed
    
    // MARK: - Generic
    case unknown(Error)
    case custom(String)
    
    // MARK: - LocalizedError Conformance
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return error.localizedDescription
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError(let message):
            return "Failed to decode data: \(message)"
        case .unauthorized:
            return "Session expired. Please log in again"
        case .serverError(let code, let message):
            return message ?? "Server error (\(code))"
        case .validationError(let message):
            return "Validation error: \(message)"
        case .invalidInput(let field):
            return "Invalid input for \(field)"
        case .userNotFound:
            return "User not found"
        case .curriculumNotFound:
            return "Curriculum not found"
        case .roadmapNotFound:
            return "Roadmap not found"
        case .skillNotFound:
            return "Skill not found"
        case .fileUploadFailed(let reason):
            return "File upload failed: \(reason)"
        case .imageProcessingFailed:
            return "Failed to process image"
        case .unknown(let error):
            return error.localizedDescription
        case .custom(let message):
            return message
        }
    }
    
    /// User-friendly message for UI display
    var userFriendlyMessage: String {
        switch self {
        case .networkError:
            return "Connection problem. Please check your internet."
        case .unauthorized:
            return "Your session has expired. Please sign in again."
        case .serverError:
            return "Server is temporarily unavailable. Please try again later."
        default:
            return errorDescription ?? "Something went wrong. Please try again."
        }
    }
    
    /// Whether error should trigger retry mechanism
    var isRetryable: Bool {
        switch self {
        case .networkError, .serverError, .invalidResponse:
            return true
        default:
            return false
        }
    }
}

// MARK: - Equatable Conformance
extension AppError: Equatable {
    static func == (lhs: AppError, rhs: AppError) -> Bool {
        switch (lhs, rhs) {
        case (.networkError(let lhsError), .networkError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.invalidResponse, .invalidResponse):
            return true
        case (.decodingError(let lhsMsg), .decodingError(let rhsMsg)):
            return lhsMsg == rhsMsg
        case (.unauthorized, .unauthorized):
            return true
        case (.serverError(let lhsCode, let lhsMsg), .serverError(let rhsCode, let rhsMsg)):
            return lhsCode == rhsCode && lhsMsg == rhsMsg
        case (.validationError(let lhsMsg), .validationError(let rhsMsg)):
            return lhsMsg == rhsMsg
        case (.invalidInput(let lhsField), .invalidInput(let rhsField)):
            return lhsField == rhsField
        case (.userNotFound, .userNotFound):
            return true
        case (.curriculumNotFound, .curriculumNotFound):
            return true
        case (.roadmapNotFound, .roadmapNotFound):
            return true
        case (.skillNotFound, .skillNotFound):
            return true
        case (.fileUploadFailed(let lhsReason), .fileUploadFailed(let rhsReason)):
            return lhsReason == rhsReason
        case (.imageProcessingFailed, .imageProcessingFailed):
            return true
        case (.unknown(let lhsError), .unknown(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.custom(let lhsMsg), .custom(let rhsMsg)):
            return lhsMsg == rhsMsg
        default:
            return false
        }
    }
}
