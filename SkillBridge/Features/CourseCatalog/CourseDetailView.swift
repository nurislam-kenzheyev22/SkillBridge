//
//  CourseDetailView.swift
//  SkillBridge
//
//  Course Detail Screen - Production Ready
//

import SwiftUI

struct CourseDetailView: View {
    let course: Course
    @StateObject private var viewModel: CourseDetailViewModel
    @Environment(\.dismiss) var dismiss
    
    init(course: Course) {
        self.course = course
        _viewModel = StateObject(wrappedValue: CourseDetailViewModel(course: course))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                // Header Image/Icon
                headerSection
                
                // Course Info
                courseInfoSection
                
                // Description
                descriptionSection
                
                // Skills Covered
                skillsSection
                
                // Details
                detailsSection
                
                // Actions
                actionsSection
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.bottom, AppSpacing.xl)
        }
        .navigationTitle("Course Details")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.toggleFavorite()
                }) {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isFavorite ? AppColors.error : AppColors.textPrimary)
                }
            }
        }
    }
    
    // MARK: - View Sections
    
    private var headerSection: some View {
        VStack(spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.primary.opacity(0.2), AppColors.secondary.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "book.fill")
                    .font(.system(size: 50))
                    .foregroundColor(AppColors.primary)
            }
            
            Text(course.title)
                .font(AppFonts.title1)
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, AppSpacing.lg)
    }
    
    private var courseInfoSection: some View {
        VStack(spacing: AppSpacing.md) {
            // Provider
            HStack {
                Text("Provider")
                    .font(AppFonts.subheadline)
                    .foregroundColor(AppColors.textSecondary)
                Spacer()
                Text(course.provider)
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
            }
            
            // Level
            HStack {
                Text("Level")
                    .font(AppFonts.subheadline)
                    .foregroundColor(AppColors.textSecondary)
                Spacer()
                Text(course.level.rawValue)
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.vertical, AppSpacing.sm)
                    .background(AppColors.surface)
                    .cornerRadius(AppCornerRadius.small)
            }
            
            // Duration
            HStack {
                Text("Duration")
                    .font(AppFonts.subheadline)
                    .foregroundColor(AppColors.textSecondary)
                Spacer()
                Text("\(course.durationWeeks) weeks")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
            }
            
            // Price
            HStack {
                Text("Price")
                    .font(AppFonts.subheadline)
                    .foregroundColor(AppColors.textSecondary)
                Spacer()
                if course.price > 0 {
                    Text("$\(Int(course.price))")
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.primary)
                } else {
                    Text("Free")
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.success)
                }
            }
            
            // Rating
            if let rating = course.rating {
                HStack {
                    Text("Rating")
                        .font(AppFonts.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(AppColors.warning)
                            .font(.system(size: 14))
                        Text(String(format: "%.1f", rating))
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.textPrimary)
                    }
                }
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .cornerRadius(AppCornerRadius.medium)
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Description")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)
            
            Text(course.description)
                .font(AppFonts.body)
                .foregroundColor(AppColors.textSecondary)
        }
    }
    
    private var skillsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Skills Covered")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)
            
            if !course.skills.isEmpty {
                let skills = MockData.allSkills.filter { course.skills.contains($0.id) }
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppSpacing.sm) {
                    ForEach(skills) { skill in
                        SkillTag(skill: skill)
                    }
                }
            } else {
                Text("No skills listed")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textTertiary)
            }
        }
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Course Details")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: AppSpacing.sm) {
                DetailRow(icon: "clock.fill", title: "Duration", value: "\(course.durationWeeks) weeks")
                DetailRow(icon: "dollarsign.circle.fill", title: "Price", value: course.price > 0 ? "$\(Int(course.price))" : "Free")
                DetailRow(icon: "chart.bar.fill", title: "Level", value: course.level.rawValue)
                if course.url != nil {
                    DetailRow(icon: "link", title: "Website", value: "Open")
                }
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .cornerRadius(AppCornerRadius.medium)
    }
    
    private var actionsSection: some View {
        VStack(spacing: AppSpacing.md) {
            // Add to Roadmap Button
            PrimaryButton(
                title: "Add to Roadmap",
                action: {
                    viewModel.addToRoadmap()
                },
                icon: "plus.circle.fill"
            )
            
            // Open Course Button
            if let url = course.url {
                SecondaryButton(
                    title: "Open Course",
                    action: {
                        if let url = URL(string: url) {
                            UIApplication.shared.open(url)
                        }
                    },
                    icon: "arrow.up.right.square"
                )
            }
        }
    }
}

struct SkillTag: View {
    let skill: Skill
    
    var body: some View {
        HStack(spacing: AppSpacing.xs) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(AppColors.success)
                .font(.system(size: 12))
            Text(skill.name)
                .font(AppFonts.caption)
                .foregroundColor(AppColors.textPrimary)
        }
        .padding(.horizontal, AppSpacing.sm)
        .padding(.vertical, AppSpacing.xs)
        .background(AppColors.success.opacity(0.1))
        .cornerRadius(AppCornerRadius.small)
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(AppColors.primary)
                .font(.system(size: 16))
                .frame(width: 24)
            
            Text(title)
                .font(AppFonts.body)
                .foregroundColor(AppColors.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(AppFonts.body)
                .foregroundColor(AppColors.textPrimary)
        }
    }
}

class CourseDetailViewModel: ObservableObject {
    @Published var isFavorite: Bool = false
    @Published var isInRoadmap: Bool = false
    
    private let course: Course
    private let userDefaults: UserDefaults
    
    init(course: Course, userDefaults: UserDefaults = .standard) {
        self.course = course
        self.userDefaults = userDefaults
        loadFavoriteStatus()
    }
    
    func toggleFavorite() {
        isFavorite.toggle()
        saveFavoriteStatus()
    }
    
    func addToRoadmap() {
        // Add to roadmap logic
        isInRoadmap = true
    }
    
    private func loadFavoriteStatus() {
        if let data = userDefaults.data(forKey: "favorite_courses"),
           let favorites = try? JSONDecoder().decode(Set<UUID>.self, from: data) {
            isFavorite = favorites.contains(course.id)
        }
    }
    
    private func saveFavoriteStatus() {
        var favorites: Set<UUID> = []
        if let data = userDefaults.data(forKey: "favorite_courses"),
           let decoded = try? JSONDecoder().decode(Set<UUID>.self, from: data) {
            favorites = decoded
        }
        
        if isFavorite {
            favorites.insert(course.id)
        } else {
            favorites.remove(course.id)
        }
        
        if let encoded = try? JSONEncoder().encode(favorites) {
            userDefaults.set(encoded, forKey: "favorite_courses")
        }
    }
}
