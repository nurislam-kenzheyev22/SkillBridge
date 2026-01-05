//
//  WelcomeView.swift
//  SkillBridge
//
//  Landing Page - 2025 Design
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var welcomeViewModel: WelcomeViewModel
    
    var body: some View {
        ZStack {
            // Clean white background
            AppColors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        // Logo
                        HStack(spacing: 8) {
                            Image(systemName: "graduationcap.fill")
                                .foregroundColor(AppColors.primary)
                                .font(.title2)
                            Text("SkillBridge")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(AppColors.textPrimary)
                        }
                        
                        Spacer()
                        
                        // Header buttons
                        HStack(spacing: AppSpacing.md) {
                            Button("Demo") {
                                // Demo action
                            }
                            .font(AppFonts.subheadline)
                            .foregroundColor(AppColors.textSecondary)
                            
                            PrimaryButton(
                                title: "Sign up",
                                action: { welcomeViewModel.startOnboarding() },
                                style: .outlined
                            )
                            .frame(width: 80)
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.md)
                    
                    // Main Content
                    VStack(spacing: AppSpacing.xl) {
                        // Hero Section
                        VStack(spacing: AppSpacing.lg) {
                            Text("Your Bridge From Classroom to Career")
                                .font(.system(size: 42, weight: .bold, design: .rounded))
                                .foregroundColor(AppColors.textPrimary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, AppSpacing.lg)
                            
                            Text("Analyze curriculum and job market data to find your path. We'll help you build the skills you need for the career you want.")
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, AppSpacing.xl)
                        }
                        .padding(.top, AppSpacing.xxl)
                        
                        // Features
                        VStack(spacing: AppSpacing.lg) {
                            FeatureRow(
                                icon: "chart.line.uptrend.xyaxis",
                                title: "Data-Driven Insights",
                                description: "Identify skill gaps with our powerful analysis."
                            )
                            
                            FeatureRow(
                                icon: "list.bullet.rectangle",
                                title: "Personalized Roadmaps",
                                description: "Get a prioritized list of courses and projects."
                            )
                            
                            FeatureRow(
                                icon: "arrow.up.right",
                                title: "Career Acceleration",
                                description: "Build a future-proof skillset and get ahead."
                            )
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.xl)
                        
                        // CTA Buttons
                        VStack(spacing: AppSpacing.md) {
                            PrimaryButton(
                                title: "Get Started",
                                action: { welcomeViewModel.startOnboarding() },
                                icon: "arrow.right"
                            )
                            
                            PrimaryButton(
                                title: "Watch Demo",
                                action: {},
                                style: .outlined
                            )
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.xl)
                        .padding(.bottom, AppSpacing.xxl)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $welcomeViewModel.showOnboarding) {
            OnboardingView()
                .onDisappear {
                    // Check onboarding status when dismissed
                    welcomeViewModel.checkOnboardingStatus()
                }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            // Icon
            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.1))
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .foregroundColor(AppColors.primary)
                    .font(.system(size: 20))
            }
            
            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Text(description)
                    .font(AppFonts.subheadline)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
        }
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .cornerRadius(AppCornerRadius.medium)
    }
}
