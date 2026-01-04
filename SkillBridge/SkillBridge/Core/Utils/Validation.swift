//
//  Validation.swift
//  SkillBridge
//
//  Input validation utilities following Clean Code principles
//

import Foundation

/// Validation result type
enum ValidationResult {
    case valid
    case invalid(String)
    
    var isValid: Bool {
        if case .valid = self {
            return true
        }
        return false
    }
    
    var errorMessage: String? {
        if case .invalid(let message) = self {
            return message
        }
        return nil
    }
}

/// Input validation utilities
struct Validator {
    
    // MARK: - Email Validation
    static func validateEmail(_ email: String) -> ValidationResult {
        guard !email.isEmpty else {
            return .invalid("Email is required")
        }
        
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        guard emailPredicate.evaluate(with: email) else {
            return .invalid("Please enter a valid email address")
        }
        
        return .valid
    }
    
    // MARK: - Password Validation
    static func validatePassword(_ password: String) -> ValidationResult {
        guard !password.isEmpty else {
            return .invalid("Password is required")
        }
        
        guard password.count >= 8 else {
            return .invalid("Password must be at least 8 characters")
        }
        
        // Check for at least one uppercase, one lowercase, and one number
        let hasUppercase = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        let hasLowercase = password.rangeOfCharacter(from: .lowercaseLetters) != nil
        let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        
        guard hasUppercase && hasLowercase && hasNumber else {
            return .invalid("Password must contain uppercase, lowercase, and number")
        }
        
        return .valid
    }
    
    // MARK: - Name Validation
    static func validateName(_ name: String) -> ValidationResult {
        guard !name.isEmpty else {
            return .invalid("Name is required")
        }
        
        guard name.count >= 2 else {
            return .invalid("Name must be at least 2 characters")
        }
        
        guard name.count <= 50 else {
            return .invalid("Name must be less than 50 characters")
        }
        
        return .valid
    }
    
    // MARK: - Year Validation
    static func validateYear(_ year: Int) -> ValidationResult {
        guard year >= 1 && year <= 6 else {
            return .invalid("Year must be between 1 and 6")
        }
        return .valid
    }
    
    // MARK: - Weekly Hours Validation
    static func validateWeeklyHours(_ hours: Int) -> ValidationResult {
        guard hours >= 1 && hours <= 40 else {
            return .invalid("Weekly hours must be between 1 and 40")
        }
        return .valid
    }
    
    // MARK: - Target Role Validation
    static func validateTargetRole(_ role: String) -> ValidationResult {
        guard !role.isEmpty else {
            return .invalid("Target role is required")
        }
        
        guard role.count >= 3 else {
            return .invalid("Target role must be at least 3 characters")
        }
        
        return .valid
    }
}
