//
//  SettingsViewModel.swift
//  SkillBridge
//
//  ViewModel for Settings Screen
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var showResetConfirmation = false
    @Published var showClearDataConfirmation = false
    @Published var showSuccessAlert = false
    @Published var successMessage = ""
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func resetOnboarding() {
        // Clear onboarding status
        userDefaults.removeObject(forKey: AppConstants.UserDefaultsKeys.hasCompletedOnboarding)
        userDefaults.removeObject(forKey: AppConstants.UserDefaultsKeys.selectedUniversity)
        userDefaults.removeObject(forKey: AppConstants.UserDefaultsKeys.selectedProgram)
        userDefaults.synchronize()
        
        successMessage = "Onboarding has been reset. Please restart the app to see Welcome Screen."
        showSuccessAlert = true
        
        // Post notification to update ContentView
        NotificationCenter.default.post(name: NSNotification.Name("ResetOnboarding"), object: nil)
    }
    
    func clearAllData() {
        // Clear all UserDefaults keys
        if let bundleID = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: bundleID)
        }
        
        // Also clear specific keys
        userDefaults.removeObject(forKey: AppConstants.UserDefaultsKeys.hasCompletedOnboarding)
        userDefaults.removeObject(forKey: AppConstants.UserDefaultsKeys.selectedUniversity)
        userDefaults.removeObject(forKey: AppConstants.UserDefaultsKeys.selectedProgram)
        userDefaults.synchronize()
        
        successMessage = "All data has been cleared. Please restart the app."
        showSuccessAlert = true
        
        // Post notification to update ContentView
        NotificationCenter.default.post(name: NSNotification.Name("ClearAllData"), object: nil)
    }
}
