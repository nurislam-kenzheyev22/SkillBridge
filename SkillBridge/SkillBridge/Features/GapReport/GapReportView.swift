//
//  GapReportView.swift
//  SkillBridge
//
//  Gap Report - Clean Code, UI/UX best practices
//

import SwiftUI

struct GapReportView: View {
    @StateObject private var viewModel = GapReportViewModel()
    @State private var userId: UUID?
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                LoadingView(message: "Loading gap report...")
            } else if let gapReport = viewModel.gapReport {
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        // Readiness Score
                        Card {
                            VStack(spacing: AppSpacing.md) {
                                Text("Readiness Score")
                                    .font(AppFonts.title3)
                                    .foregroundColor(AppColors.textPrimary)
                                
                                ProgressCircle(
                                    progress: gapReport.readinessScore / 100,
                                    size: 120,
                                    lineWidth: 12
                                )
                                
                                Text("\(Int(gapReport.readinessScore))%")
                                    .font(AppFonts.title1)
                                    .foregroundColor(AppColors.primary)
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.md)
                        
                        // Skill Gaps
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            Text("Skill Gaps")
                                .font(AppFonts.title2)
                                .foregroundColor(AppColors.textPrimary)
                                .padding(.horizontal, AppSpacing.lg)
                            
                            ForEach(gapReport.skillGaps) { gap in
                                SkillGapCard(gap: gap)
                                    .padding(.horizontal, AppSpacing.lg)
                            }
                        }
                    }
                    .padding(.bottom, AppSpacing.xl)
                }
            } else {
                EmptyStateView(
                    icon: "chart.bar.fill",
                    title: "No Gap Report",
                    message: "Complete onboarding to generate your gap report"
                )
            }
        }
        .navigationTitle("Gap Report")
        .navigationBarTitleDisplayMode(.large)
        .task {
            if let user = try? await APIService.shared.getCurrentUser() {
                userId = user.id
                await viewModel.fetchGapReport(userId: user.id)
            }
        }
    }
}

struct SkillGapCard: View {
    let gap: SkillGap
    
    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                HStack {
                    Text(gap.skillName)
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Text("\(Int(gap.gap))% gap")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.error)
                        .padding(.horizontal, AppSpacing.sm)
                        .padding(.vertical, 4)
                        .background(AppColors.error.opacity(0.1))
                        .cornerRadius(AppCornerRadius.small)
                }
                
                // Progress bars
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Current: \(Int(gap.currentLevel))%")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.textSecondary)
                        Spacer()
                        Text("Required: \(Int(gap.requiredLevel))%")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppColors.surface)
                                .frame(height: 8)
                            
                            // Current progress
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppColors.primary)
                                .frame(width: geometry.size.width * CGFloat(gap.currentLevel / 100), height: 8)
                            
                            // Required indicator
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppColors.error)
                                .frame(width: geometry.size.width * CGFloat(gap.requiredLevel / 100), height: 8)
                                .opacity(0.3)
                        }
                    }
                    .frame(height: 8)
                }
            }
        }
    }
}
