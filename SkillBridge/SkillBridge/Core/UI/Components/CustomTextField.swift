//
//  CustomTextField.swift
//  SkillBridge
//
//  Custom Text Field Component
//

import SwiftUI

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    var placeholder: String = ""
    var icon: String? = nil
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(title)
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)
            
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .font(AppFonts.body)
                } else {
                    TextField(placeholder, text: $text)
                        .font(AppFonts.body)
                }
            }
            .padding(AppSpacing.md)
            .background(AppColors.surface)
            .cornerRadius(AppCornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .stroke(AppColors.border, lineWidth: 1)
            )
        }
    }
}
