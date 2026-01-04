//
//  Constants.swift
//  SkillBridge
//
//  App-wide constants - Updated for 2025 Design
//

import Foundation

struct AppConstants {
    // API Configuration
    static let baseURL = "http://127.0.0.1:8000"
    static let apiVersion = "v1"
    
    // Keychain Keys
    struct KeychainKeys {
        static let accessToken = "access_token"
        static let refreshToken = "refresh_token"
        static let userId = "user_id"
    }
    
    // UserDefaults Keys
    struct UserDefaultsKeys {
        static let hasCompletedOnboarding = "has_completed_onboarding"
        static let currentUserId = "current_user_id"
        static let selectedUniversity = "selected_university"
        static let selectedProgram = "selected_program"
    }
}
