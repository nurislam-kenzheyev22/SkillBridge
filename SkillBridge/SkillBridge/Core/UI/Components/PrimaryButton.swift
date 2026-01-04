//
//  PrimaryButton.swift
//  SkillBridge
//
//  Primary Button Component - 2025 Design
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var icon: String? = nil
    var isEnabled: Bool = true
    var isLoading: Bool = false
    var style: ButtonStyle = .filled
    
    enum ButtonStyle {
        case filled
        case outlined
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: style == .filled ? .white : AppColors.primary))
                } else if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(title)
                    .font(AppFonts.headline)
            }
            .foregroundColor(style == .filled ? .white : AppColors.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(
                Group {
                    if style == .filled {
                        isEnabled ? AppColors.primary : AppColors.textTertiary
                    } else {
                        Color.clear
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .stroke(style == .outlined ? AppColors.primary : Color.clear, lineWidth: 2)
            )
            .cornerRadius(AppCornerRadius.medium)
        }
        .disabled(!isEnabled || isLoading)
    }
}
