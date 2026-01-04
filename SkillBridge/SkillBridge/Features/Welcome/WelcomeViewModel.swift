//
//  WelcomeViewModel.swift
//  SkillBridge
//
//  ViewModel for Welcome Screen - MVVM Architecture
//

import Foundation
import SwiftUI

class WelcomeViewModel: ObservableObject {
    @Published var showOnboarding = false
    @Published var hasCompletedOnboarding: Bool = false
    
    init() {
        checkOnboardingStatus()
    }
    
    func checkOnboardingStatus() {
        hasCompletedOnboarding = UserDefaults.standard.bool(
            forKey: AppConstants.UserDefaultsKeys.hasCompletedOnboarding
        )
    }
    
    func startOnboarding() {
        showOnboarding = true
    }
}
