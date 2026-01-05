//
//  OnboardingStep2View.swift
//  SkillBridge
//
//  Step 2: Skills Assessment - 2025 Design
//

import SwiftUI

struct OnboardingStep2View: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    viewModel.previousStep()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(AppColors.textPrimary)
                        .font(.system(size: 18, weight: .semibold))
                }
                
                Text("Skills")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
            
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    // Header Text
                    Text("What skills do you have?")
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.textPrimary)
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.md)
                    
                    // Skills by Category
                    ForEach(SkillCategory.allCases, id: \.self) { category in
                        let categorySkills = viewModel.availableSkills.filter { $0.category == category }
                        
                        if !categorySkills.isEmpty {
                            VStack(alignment: .leading, spacing: AppSpacing.md) {
                                Text(category.rawValue)
                                    .font(AppFonts.headline)
                                    .foregroundColor(AppColors.textPrimary)
                                    .padding(.horizontal, AppSpacing.lg)
                                
                                VStack(spacing: AppSpacing.sm) {
                                    ForEach(categorySkills) { skill in
                                        SkillCheckboxRow(
                                            skill: skill,
                                            isSelected: viewModel.selectedSkills.contains(skill.id)
                                        ) {
                                            // Use Task to avoid publishing during view update
                                            Task { @MainActor in
                                                if viewModel.selectedSkills.contains(skill.id) {
                                                    viewModel.selectedSkills.remove(skill.id)
                                                } else {
                                                    viewModel.selectedSkills.insert(skill.id)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, AppSpacing.lg)
                            }
                        }
                    }
                    
                    Spacer(minLength: AppSpacing.xl)
                    
                    // Navigation Buttons
                    HStack(spacing: AppSpacing.md) {
                        PrimaryButton(
                            title: "Back",
                            action: { viewModel.previousStep() },
                            style: .outlined
                        )
                        
                        PrimaryButton(
                            title: "Next",
                            action: { viewModel.nextStep() },
                            icon: "arrow.right",
                            isEnabled: viewModel.canProceedFromStep2
                        )
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.xl)
                }
            }
        }
    }
}

struct SkillCheckboxRow: View {
    let skill: Skill
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .foregroundColor(isSelected ? AppColors.primary : AppColors.textTertiary)
                    .font(.system(size: 20))
                
                Text(skill.name)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            .padding(AppSpacing.md)
            .background(isSelected ? AppColors.primary.opacity(0.1) : AppColors.surface)
            .cornerRadius(AppCornerRadius.medium)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
