//
//  OnboardingView.swift
//  SkillBridge
//
//  Onboarding Flow - Beautiful Design
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Background
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress Indicator
                ProgressIndicator(currentStep: viewModel.currentStep, totalSteps: 3)
                    .padding(.top, AppSpacing.xl)
                    .padding(.horizontal, AppSpacing.lg)
                
                // Content
                TabView(selection: $viewModel.currentStep) {
                    OnboardingStep1View(viewModel: viewModel)
                        .tag(0)
                    
                    OnboardingStep2View(viewModel: viewModel)
                        .tag(1)
                    
                    OnboardingStep3View(viewModel: viewModel, dismiss: dismiss)
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
    }
}

// Progress Indicator Component
struct ProgressIndicator: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            ForEach(0..<totalSteps, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(index <= currentStep ? AppColors.primary : AppColors.border)
                    .frame(height: 4)
                    .animation(.spring(), value: currentStep)
            }
        }
    }
}
