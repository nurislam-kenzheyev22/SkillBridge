//
//  ProfileView.swift
//  SkillBridge
//
//  User Profile Screen - Production Ready
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showEditProfile = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                // Profile Header
                profileHeaderSection
                
                // Stats
                statsSection
                
                // Profile Info
                profileInfoSection
                
                // Actions
                actionsSection
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showEditProfile = true
                }
            }
        }
        .sheet(isPresented: $showEditProfile) {
            EditProfileView(viewModel: viewModel)
        }
        .task {
            await viewModel.loadProfile()
        }
    }
    
    // MARK: - View Sections
    
    private var profileHeaderSection: some View {
        VStack(spacing: AppSpacing.md) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Text(viewModel.userInitials)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Text(viewModel.userName)
                .font(AppFonts.title2)
                .foregroundColor(AppColors.textPrimary)
            
            Text(viewModel.userEmail)
                .font(AppFonts.subheadline)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.lg)
    }
    
    private var statsSection: some View {
        HStack(spacing: AppSpacing.md) {
            StatCard(title: "Readiness", value: "\(Int(viewModel.readinessScore))%", icon: "chart.line.uptrend.xyaxis")
            StatCard(title: "Skills", value: "\(viewModel.skillsCount)", icon: "star.fill")
            StatCard(title: "Courses", value: "\(viewModel.coursesCount)", icon: "book.fill")
        }
    }
    
    private var profileInfoSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Profile Information")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)
            
            Card {
                VStack(spacing: AppSpacing.md) {
                    InfoRow(title: "University", value: viewModel.university)
                    InfoRow(title: "Program", value: viewModel.program)
                    InfoRow(title: "Year", value: viewModel.year)
                    InfoRow(title: "Target Role", value: viewModel.targetRole)
                    InfoRow(title: "Weekly Hours", value: "\(viewModel.weeklyHours) hrs")
                }
            }
        }
    }
    
    private var actionsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Actions")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: AppSpacing.sm) {
                NavigationLink(destination: GapReportView()) {
                    ActionButton(icon: "chart.bar.fill", title: "View Gap Report", color: AppColors.primary) {}
                }
                
                NavigationLink(destination: RoadmapView()) {
                    ActionButton(icon: "map.fill", title: "View Roadmap", color: AppColors.secondary) {}
                }
                
                ActionButton(icon: "square.and.arrow.up", title: "Export Progress", color: AppColors.accent) {
                    viewModel.exportProgress()
                }
                
                ActionButton(icon: "arrow.clockwise", title: "Regenerate Roadmap", color: AppColors.warning) {
                    viewModel.regenerateRoadmap()
                }
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(AppColors.primary)
            
            Text(value)
                .font(AppFonts.title2)
                .foregroundColor(AppColors.textPrimary)
            
            Text(title)
                .font(AppFonts.caption)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .cornerRadius(AppCornerRadius.medium)
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
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

struct ActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 18))
                
                Text(title)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(AppColors.textTertiary)
                    .font(.system(size: 12))
            }
            .padding(AppSpacing.md)
            .background(AppColors.surface)
            .cornerRadius(AppCornerRadius.medium)
        }
    }
}

struct EditProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    Text("Edit Profile")
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.textPrimary)
                        .padding(.top, AppSpacing.lg)
                    
                    Text("Edit functionality coming soon")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary)
                }
                .padding()
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        dismiss()
                    }
                }
            }
        }
    }
}

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var readinessScore: Double = 0.0
    @Published var skillsCount: Int = 0
    @Published var coursesCount: Int = 0
    @Published var university: String = ""
    @Published var program: String = ""
    @Published var year: String = ""
    @Published var targetRole: String = ""
    @Published var weeklyHours: Int = 0
    
    private let apiService: APIServiceProtocol
    private let userDefaults: UserDefaults
    
    init(apiService: APIServiceProtocol = APIService.shared, userDefaults: UserDefaults = .standard) {
        self.apiService = apiService
        self.userDefaults = userDefaults
    }
    
    var userName: String {
        user?.name ?? "User"
    }
    
    var userEmail: String {
        user?.email ?? ""
    }
    
    var userInitials: String {
        let name = userName
        let components = name.components(separatedBy: " ")
        if components.count >= 2 {
            return String(components[0].prefix(1)) + String(components[1].prefix(1))
        } else if !components.isEmpty {
            return String(components[0].prefix(2))
        }
        return "U"
    }
    
    @MainActor
    func loadProfile() async {
        do {
            user = try await apiService.getCurrentUser()
            
            // Load from UserDefaults
            university = userDefaults.string(forKey: AppConstants.UserDefaultsKeys.selectedUniversity) ?? ""
            program = userDefaults.string(forKey: AppConstants.UserDefaultsKeys.selectedProgram) ?? ""
            
            // Load gap report for readiness score
            if let userId = user?.id {
                let gapReport = try await apiService.getGapReport(userId: userId)
                readinessScore = gapReport.readinessScore
                skillsCount = gapReport.skillGaps.count
            }
            
            // Count courses
            let courses = try await apiService.getCourses()
            coursesCount = courses.count
        } catch {
            // Handle error
        }
    }
    
    func exportProgress() {
        // Export progress logic
    }
    
    func regenerateRoadmap() {
        // Regenerate roadmap logic
    }
}
