//
//  AccessibleButton.swift
//  SkillBridge
//
//  Accessible button component following UI/UX and Accessibility best practices
//

import SwiftUI

/// Enhanced button with full accessibility support
struct AccessibleButton: View {
    let title: String
    let action: () -> Void
    var icon: String? = nil
    var accessibilityLabel: String?
    var accessibilityHint: String?
    var role: ButtonRole = .primary
    var isEnabled: Bool = true
    var isLoading: Bool = false
    
    enum ButtonRole {
        case primary
        case secondary
        case destructive
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: buttonTextColor))
                } else if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(title)
                    .font(AppFonts.headline)
            }
            .foregroundColor(buttonTextColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(buttonBackgroundColor)
            .cornerRadius(AppCornerRadius.medium)
        }
        .disabled(!isEnabled || isLoading)
        .accessibilityLabel(accessibilityLabel ?? title)
        .accessibilityHint(accessibilityHint ?? "")
        .accessibilityElement(children: .combine)
        // Note: .disabled() automatically makes element inaccessible to VoiceOver
        // No need for explicit accessibilityDisabled modifier
    }
    
    private var buttonTextColor: Color {
        switch role {
        case .primary:
            return .white
        case .secondary:
            return AppColors.primary
        case .destructive:
            return .white
        }
    }
    
    private var buttonBackgroundColor: Color {
        if !isEnabled {
            return AppColors.textTertiary
        }
        
        switch role {
        case .primary:
            return AppColors.primary
        case .secondary:
            return AppColors.primary.opacity(0.1)
        case .destructive:
            return AppColors.error
        }
    }
}
