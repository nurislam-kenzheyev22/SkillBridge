//
//  DashboardView.swift
//  SkillBridge
//
//  Dashboard - Clean Code, UI/UX best practices with Animated Progress
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            if viewModel.isLoading && viewModel.user == nil {
                // Skeleton Loaders
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        SkeletonCard()
                        SkeletonCard()
                        SkeletonCard()
                    }
                    .padding()
                }
            } else if let error = viewModel.error {
                ErrorView(
                    error: error,
                    onRetry: {
                        Task {
                            await viewModel.loadDashboard()
                        }
                    }
                )
            } else {
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        // Header
                        headerSection
                        
                        // Readiness Score
                        readinessScoreCard
                        
                        // Top Missing Skills
                        topMissingSkillsCard
                        
                        // Roadmap Preview
                        roadmapPreviewCard
                        
                        // Quick Actions
                        quickActionsCard
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.md)
                }
                .refreshable {
                    await viewModel.refresh()
                }
            }
        }
        .navigationTitle("Dashboard")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.loadDashboard()
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            if let user = viewModel.user {
                Text("Welcome back, \(user.name)!")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.textPrimary)
            } else {
                Text("Welcome!")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.textPrimary)
            }
            
            Text("Here's your learning progress")
                .font(AppFonts.subheadline)
                .foregroundColor(AppColors.textSecondary)
        }
    }
    
    private var readinessScoreCard: some View {
        Card {
            VStack(spacing: AppSpacing.md) {
                HStack {
                    Text("Readiness Score")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Text("\(Int(viewModel.readinessScore))%")
                        .font(AppFonts.title1)
                        .foregroundColor(AppColors.primary)
                }
                
                // Animated Progress Bar
                AnimatedProgressBar(progress: viewModel.readinessScore / 100.0, height: 8)
            }
        }
    }
    
    private var topMissingSkillsCard: some View {
        Card {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                Text("Top Missing Skills")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                if let gapReport = viewModel.gapReport, !gapReport.skillGaps.isEmpty {
                    VStack(spacing: AppSpacing.sm) {
                        ForEach(Array(gapReport.skillGaps.prefix(4))) { gap in
                            SkillGapRow(gap: gap)
                        }
                    }
                } else {
                    Text("No skill gaps found")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
    }
    
    private var roadmapPreviewCard: some View {
        Card {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                HStack {
                    Text("Learning Roadmap")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    NavigationLink(destination: RoadmapView()) {
                        Text("View All")
                            .font(AppFonts.subheadline)
                            .foregroundColor(AppColors.primary)
                    }
                }
                
                if let roadmap = viewModel.roadmap {
                    VStack(spacing: AppSpacing.sm) {
                        Text(roadmap.title)
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.textSecondary)
                        
                        Text("\(roadmap.steps.count) steps • \(roadmap.estimatedTotalHours) hours")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.textTertiary)
                        
                        // Animated Progress
                        AnimatedProgressBar(progress: roadmap.progress, height: 6)
                    }
                } else {
                    Text("No roadmap available")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
    }
    
    private var quickActionsCard: some View {
        Card {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                Text("Quick Actions")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                HStack(spacing: AppSpacing.md) {
                    NavigationLink(destination: GapReportView()) {
                        QuickActionButton(icon: "chart.bar.fill", title: "Gap Report")
                    }
                    
                    NavigationLink(destination: CourseCatalogView()) {
                        QuickActionButton(icon: "book.fill", title: "Courses")
                    }
                    
                    NavigationLink(destination: RoadmapView()) {
                        QuickActionButton(icon: "map.fill", title: "Roadmap")
                    }
                }
            }
        }
    }
}

struct SkillGapRow: View {
    let gap: SkillGap
    
    var body: some View {
        HStack {
            Text(gap.skillName)
                .font(AppFonts.body)
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            HStack(spacing: AppSpacing.xs) {
                Text("\(Int(gap.currentLevel))%")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.textSecondary)
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 10))
                    .foregroundColor(AppColors.textTertiary)
                
                Text("\(Int(gap.requiredLevel))%")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.primary)
            }
        }
        .padding(.vertical, AppSpacing.xs)
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(AppColors.primary)
            
            Text(title)
                .font(AppFonts.caption)
                .foregroundColor(AppColors.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .cornerRadius(AppCornerRadius.medium)
    }
}
