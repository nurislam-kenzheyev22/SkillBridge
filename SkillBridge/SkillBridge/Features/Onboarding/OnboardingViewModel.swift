//
//  OnboardingViewModel.swift
//  SkillBridge
//
//  ViewModel for Onboarding Flow - Clean Code & SOLID principles
//

import Foundation
import SwiftUI
import Combine

/// ViewModel following Single Responsibility Principle
/// Handles only onboarding logic
final class OnboardingViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentStep: Int = 0
    @Published var isLoading: Bool = false
    @Published var error: AppError?
    @Published var validationErrors: [String: String] = [:]
    
    // MARK: - Step 1: Profile Data (Empty by default - user must fill)
    @Published var selectedUniversity: String = "" {
        didSet { validateStep1IfNeeded() }
    }
    @Published var selectedProgram: String = "" {
        didSet { validateStep1IfNeeded() }
    }
    @Published var selectedYear: Int = 1 {
        didSet { validateStep1IfNeeded() }
    }
    @Published var targetRole: String = "" {
        didSet { validateStep1IfNeeded() }
    }
    @Published var weeklyHours: Int = 10 {
        didSet { validateStep1IfNeeded() }
    }
    @Published var budget: String = "Any"
    @Published var ovzFlag: Bool = false
    @Published var internetQuality: String = "High"
    
    // MARK: - Step 2: Skills Data (Empty by default - user must select)
    @Published var selectedSkills: Set<UUID> = []
    
    // MARK: - Step 3: Curriculum Data
    @Published var selectedFile: URL?
    @Published var uploadOption: UploadOption = .upload
    
    // MARK: - Constants
    private let totalSteps = 3
    
    // MARK: - Dependencies (Dependency Inversion Principle)
    private let userDefaults: UserDefaults
    private let validator: Validator.Type
    
    // MARK: - Initialization
    init(
        userDefaults: UserDefaults = .standard,
        validator: Validator.Type = Validator.self
    ) {
        self.userDefaults = userDefaults
        self.validator = validator
    }
    
    // MARK: - Navigation
    func nextStep() {
        guard canProceedFromCurrentStep else { return }
        
        // Validate before proceeding
        if currentStep == 0 {
            _ = validateStep1()
        }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            if currentStep < totalSteps - 1 {
                currentStep += 1
            } else {
                completeOnboarding()
            }
        }
    }
    
    func previousStep() {
        guard currentStep > 0 else { return }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            currentStep -= 1
            clearValidationErrors()
        }
    }
    
    // MARK: - Validation (Single Responsibility)
    var canProceedFromStep1: Bool {
        // Read-only check without modifying state
        return !selectedUniversity.isEmpty &&
               !selectedProgram.isEmpty &&
               selectedYear >= 1 && selectedYear <= 6 &&
               !targetRole.isEmpty &&
               weeklyHours >= 1 && weeklyHours <= 40
    }
    
    var canProceedFromStep2: Bool {
        !selectedSkills.isEmpty
    }
    
    var canProceedFromCurrentStep: Bool {
        switch currentStep {
        case 0: return canProceedFromStep1
        case 1: return canProceedFromStep2
        case 2: return true // Step 3 doesn't require validation
        default: return false
        }
    }
    
    // Validation that can modify state (called from didSet)
    private func validateStep1IfNeeded() {
        // Use Task to avoid publishing during view update
        Task { @MainActor in
            _ = validateStep1()
        }
    }
    
    // Full validation with error messages
    private func validateStep1() -> ValidationResult {
        var errors: [String: String] = [:]
        
        // Validate university
        if selectedUniversity.isEmpty {
            errors["university"] = "Please select a university"
        }
        
        // Validate program
        if selectedProgram.isEmpty {
            errors["program"] = "Please select a program"
        }
        
        // Validate year
        let yearValidation = validator.validateYear(selectedYear)
        if !yearValidation.isValid {
            errors["year"] = yearValidation.errorMessage ?? "Invalid year"
        }
        
        // Validate target role
        let roleValidation = validator.validateTargetRole(targetRole)
        if !roleValidation.isValid {
            errors["targetRole"] = roleValidation.errorMessage ?? "Invalid target role"
        }
        
        // Validate weekly hours
        let hoursValidation = validator.validateWeeklyHours(weeklyHours)
        if !hoursValidation.isValid {
            errors["weeklyHours"] = hoursValidation.errorMessage ?? "Invalid weekly hours"
        }
        
        // Update validation errors
        validationErrors = errors
        
        if errors.isEmpty {
            return .valid
        } else {
            return .invalid(errors.values.first ?? "Validation failed")
        }
    }
    
    func clearValidationErrors() {
        validationErrors.removeAll()
    }
    
    // MARK: - Onboarding Completion
    func completeOnboarding() {
        isLoading = true
        error = nil
        
        // Save onboarding completion
        userDefaults.set(true, forKey: AppConstants.UserDefaultsKeys.hasCompletedOnboarding)
        userDefaults.set(selectedUniversity, forKey: AppConstants.UserDefaultsKeys.selectedUniversity)
        userDefaults.set(selectedProgram, forKey: AppConstants.UserDefaultsKeys.selectedProgram)
        
        // Simulate async operation
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            isLoading = false
        }
    }
    
    // MARK: - Mock Data (using MockData)
    var universities: [String] {
        MockData.universities
    }
    
    var programs: [String] {
        MockData.programs
    }
    
    var targetRoles: [String] {
        MockData.targetRoles
    }
    
    var availableSkills: [Skill] {
        MockData.allSkills
    }
    
    let years = [1, 2, 3, 4, 5, 6]
}

// MARK: - Supporting Types
enum UploadOption {
    case upload
    case manual
    case template
}
