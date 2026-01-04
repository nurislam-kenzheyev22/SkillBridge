//
//  BottomNavigationBar.swift
//  SkillBridge
//
//  Bottom Navigation Bar - 2025 Design
//

import SwiftUI

enum TabItem: String, CaseIterable {
    case dashboard = "Dashboard"
    case report = "Gap Report"
    case roadmap = "Roadmap"
    case progress = "Progress"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .dashboard: return "house.fill"
        case .report: return "chart.bar.fill"
        case .roadmap: return "map.fill"
        case .progress: return "chart.line.uptrend.xyaxis"
        case .settings: return "gearshape.fill"
        }
    }
}

struct BottomNavigationBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                Button(action: {
                    selectedTab = tab
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 20))
                            .foregroundColor(selectedTab == tab ? AppColors.primary : AppColors.textTertiary)
                        
                        Text(tab.rawValue)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(selectedTab == tab ? AppColors.primary : AppColors.textTertiary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.vertical, AppSpacing.sm)
        .background(AppColors.surfaceElevated)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(AppColors.border),
            alignment: .top
        )
    }
}
