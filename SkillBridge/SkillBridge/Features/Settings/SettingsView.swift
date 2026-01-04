//
//  SettingsView.swift
//  SkillBridge
//
//  Settings Screen with Reset functionality
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Header
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Settings")
                            .font(AppFonts.largeTitle)
                            .foregroundColor(AppColors.textPrimary)
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.md)
                    
                    // Account Section
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        Text("Account")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.textSecondary)
                            .padding(.horizontal, AppSpacing.lg)
                        
                        NavigationLink(destination: ProfileView()) {
                            SettingsRow(
                                icon: "person.fill",
                                title: "Profile",
                                subtitle: "Edit your profile information"
                            ) {
                                // Navigation handled by NavigationLink
                            }
                        }
                        .buttonStyle(PlainButtonStyle())                        
                        SettingsRow(
                            icon: "bell.fill",
                            title: "Notifications",
                            subtitle: "Manage notifications"
                        ) {
                            // Notifications action
                        }
                    }
                    .padding(.top, AppSpacing.lg)
                    
                    // Data Section
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        Text("Data")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.textSecondary)
                            .padding(.horizontal, AppSpacing.lg)
                        
                        SettingsRow(
                            icon: "arrow.clockwise",
                            title: "Reset Onboarding",
                            subtitle: "Start onboarding from scratch",
                            iconColor: AppColors.warning
                        ) {
                            viewModel.showResetConfirmation = true
                        }
                        
                        SettingsRow(
                            icon: "trash.fill",
                            title: "Clear All Data",
                            subtitle: "Remove all saved data",
                            iconColor: AppColors.error
                        ) {
                            viewModel.showClearDataConfirmation = true
                        }
                    }
                    .padding(.top, AppSpacing.lg)
                    
                    // About Section
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        Text("About")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.textSecondary)
                            .padding(.horizontal, AppSpacing.lg)
                        
                        SettingsRow(
                            icon: "info.circle.fill",
                            title: "Version",
                            subtitle: "1.0.0"
                        ) {
                            // Version info
                        }
                        
                        SettingsRow(
                            icon: "questionmark.circle.fill",
                            title: "Help & Support",
                            subtitle: "Get help and contact support"
                        ) {
                            // Help action
                        }
                    }
                    .padding(.top, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.xl)
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .alert("Reset Onboarding", isPresented: $viewModel.showResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                viewModel.resetOnboarding()
            }
        } message: {
            Text("This will reset your onboarding status. You'll need to complete onboarding again.")
        }
        .alert("Clear All Data", isPresented: $viewModel.showClearDataConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                viewModel.clearAllData()
            }
        } message: {
            Text("This will remove all saved data including onboarding status, preferences, and cached data.")
        }
        .alert("Success", isPresented: $viewModel.showSuccessAlert) {
            Button("OK") {
                // App will restart automatically
            }
        } message: {
            Text(viewModel.successMessage)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    var iconColor: Color = AppColors.primary
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                        .font(.system(size: 18))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(subtitle)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(AppColors.textTertiary)
                    .font(.system(size: 14))
            }
            .padding(AppSpacing.md)
            .background(AppColors.surface)
            .cornerRadius(AppCornerRadius.medium)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, AppSpacing.lg)
    }
}
