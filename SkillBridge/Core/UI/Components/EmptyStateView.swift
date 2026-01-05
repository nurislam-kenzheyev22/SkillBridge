//
//  EmptyStateView.swift
//  SkillBridge
//
//  Empty state component following UI/UX best practices
//

import SwiftUI

/// Empty state view for better UX when no content is available
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 64))
                .foregroundColor(AppColors.textTertiary)
            
            // Text
            VStack(spacing: AppSpacing.sm) {
                Text(title)
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.textPrimary)
                
                Text(message)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.xl)
            }
            
            // Action Button
            if let actionTitle = actionTitle, let action = action {
                PrimaryButton(
                    title: actionTitle,
                    action: action
                )
                .padding(.horizontal, AppSpacing.lg)
            }
        }
        .padding(AppSpacing.xxl)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(message)")
    }
}
