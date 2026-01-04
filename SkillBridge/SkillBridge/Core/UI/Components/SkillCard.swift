//
//  SkillCard.swift
//  SkillBridge
//
//  Skill Card Component
//

import SwiftUI

struct SkillCard: View {
    let skill: Skill
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(isSelected ? AppColors.primary : AppColors.surface)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: isSelected ? "checkmark" : "plus")
                        .foregroundColor(isSelected ? .white : AppColors.textSecondary)
                        .font(.system(size: 16, weight: .semibold))
                }
                
                // Skill info
                VStack(alignment: .leading, spacing: 4) {
                    Text(skill.name)
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    if let proficiency = skill.proficiency {
                        Text(proficiency.rawValue)
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                
                Spacer()
            }
            .padding(AppSpacing.md)
            .background(isSelected ? AppColors.primary.opacity(0.1) : AppColors.surface)
            .cornerRadius(AppCornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .stroke(isSelected ? AppColors.primary : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
