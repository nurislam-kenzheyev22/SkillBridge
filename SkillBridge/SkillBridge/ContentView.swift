//
//  ContentView.swift
//  SkillBridge
//
//  Main entry view with navigation - 2025 Design
//

import SwiftUI

struct ContentView: View {
    @StateObject private var welcomeViewModel = WelcomeViewModel()
    @State private var selectedTab: TabItem = .dashboard
    
    var body: some View {
        Group {
            if welcomeViewModel.hasCompletedOnboarding {
                MainTabView(selectedTab: $selectedTab)
            } else {
                WelcomeView()
                    .environmentObject(welcomeViewModel)
            }
        }
        .onAppear {
            welcomeViewModel.checkOnboardingStatus()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ResetOnboarding"))) { _ in
            // Reset onboarding status when notification is received
            welcomeViewModel.checkOnboardingStatus()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ClearAllData"))) { _ in
            // Reset onboarding status when notification is received
            welcomeViewModel.checkOnboardingStatus()
        }
    }
}

struct MainTabView: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            // Content based on selected tab
            Group {
                switch selectedTab {
                case .dashboard:
                    NavigationView {
                        DashboardView()
                    }
                case .report:
                    NavigationView {
                        GapReportView()
                    }
                case .roadmap:
                    NavigationView {
                        RoadmapView()
                    }
                case .progress:
                    NavigationView {
                        ProgressView()
                    }
                case .settings:
                    NavigationView {
                        SettingsView()
                    }
                }
            }
            
            // Bottom Navigation Bar
            VStack {
                Spacer()
                BottomNavigationBar(selectedTab: $selectedTab)
            }
        }
    }
}

// Placeholder views
struct ProgressView: View {
    var body: some View {
        ZStack {
            AppColors.background
            EmptyStateView(
                icon: "chart.line.uptrend.xyaxis",
                title: "Progress",
                message: "Track your learning progress here"
            )
        }
        .navigationTitle("Progress")
    }
}
