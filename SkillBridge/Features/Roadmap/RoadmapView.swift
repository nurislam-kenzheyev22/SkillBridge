//
//  RoadmapView.swift
//  SkillBridge
//
//  Roadmap - Clean Code, UI/UX best practices with Animated Progress
//

import SwiftUI

struct RoadmapView: View {
    @StateObject private var viewModel = RoadmapViewModel()
    @State private var userId: UUID?
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                LoadingView(message: "Loading roadmap...")
            } else if let roadmap = viewModel.roadmap {
                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.lg) {
                        // Header
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text(roadmap.title)
                                .font(AppFonts.title1)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text("\(Int(roadmap.progress * 100))% Complete • \(roadmap.estimatedTotalHours) hours")
                                .font(AppFonts.subheadline)
                                .foregroundColor(AppColors.textSecondary)
                            
                            // Animated Progress Bar
                            AnimatedProgressBar(progress: roadmap.progress, height: 8)
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.md)
                        
                        // Steps
                        VStack(spacing: AppSpacing.md) {
                            ForEach(roadmap.steps) { step in
                                RoadmapStepCard(
                                    step: step,
                                    onComplete: {
                                        viewModel.markStepCompleted(stepId: step.id)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.bottom, AppSpacing.xl)
                    }
                }
                .refreshable {
                    if let userId = userId {
                        await viewModel.refresh(userId: userId)
                    }
                }
            } else {
                EmptyStateView(
                    icon: "map.fill",
                    title: "No Roadmap",
                    message: "Generate a roadmap to see your learning path",
                    actionTitle: "Generate Roadmap",
                    action: {
                        // Generate roadmap action
                    }
                )
            }
        }
        .navigationTitle("Roadmap")
        .navigationBarTitleDisplayMode(.large)
        .task {
            // Get user ID from UserDefaults or API
            if let user = try? await APIService.shared.getCurrentUser() {
                userId = user.id
                await viewModel.fetchRoadmap(userId: user.id)
            }
        }
    }
}

struct RoadmapStepCard: View {
    let step: RoadmapStep
    let onComplete: () -> Void
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        Card {
            HStack(alignment: .top, spacing: AppSpacing.md) {
                // Status Icon (Interactive)
                Button(action: {
                    if step.status != .completed {
                        onComplete()
                    }
                }) {
                    Image(systemName: step.status == .completed ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(step.status == .completed ? AppColors.success : AppColors.textTertiary)
                        .font(.system(size: 24))
                }
                .disabled(step.status == .completed)
                
                // Content
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text(step.title)
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                        .strikethrough(step.status == .completed)
                    
                    Text(step.description)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary)
                    
                    HStack {
                        if let deadline = step.deadline {
                            HStack(spacing: 4) {
                                Image(systemName: "calendar")
                                    .foregroundColor(AppColors.textSecondary)
                                    .font(.system(size: 12))
                                Text(dateFormatter.string(from: deadline))
                                    .font(AppFonts.caption)
                                    .foregroundColor(AppColors.textSecondary)
                            }
                        }
                        
                        Spacer()
                        
                        Text("\(step.estHours)h")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                
                Spacer()
            }
        }
    }
}
