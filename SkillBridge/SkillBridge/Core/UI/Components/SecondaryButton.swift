//
//  SecondaryButton.swift
//  SkillBridge
//
//  Secondary Button Component
//

import SwiftUI

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var icon: String? = nil
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
                    .font(AppFonts.headline)
            }
            .foregroundColor(AppColors.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(AppColors.primary.opacity(0.1))
            .cornerRadius(AppCornerRadius.medium)
        }
    }
}
