//
//  CourseCard.swift
//  SkillBridge
//
//  Course Card Component with Navigation
//

import SwiftUI

struct CourseCard: View {
    let course: Course
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        NavigationLink(destination: CourseDetailView(course: course)) {
            Card {
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    // Header with Favorite
                    HStack {
                        // Course Title
                        Text(course.title)
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.textPrimary)
                            .lineLimit(2)
                        
                        Spacer()
                        
                        // Favorite Button
                        Button(action: onFavoriteToggle) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(isFavorite ? AppColors.error : AppColors.textTertiary)
                                .font(.system(size: 18))
                        }
                    }
                    
                    // Provider
                    Text(course.provider)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary)
                    
                    // Details
                    HStack {
                        Text("\(course.durationWeeks) weeks")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.textSecondary)
                        
                        Spacer()
                        
                        if course.price > 0 {
                            Text("$\(Int(course.price))")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.primary)
                        } else {
                            Text("Free")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.success)
                        }
                    }
                    
                    // Level
                    Text(course.level.rawValue)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary)
                        .padding(.horizontal, AppSpacing.sm)
                        .padding(.vertical, 4)
                        .background(AppColors.surface)
                        .cornerRadius(AppCornerRadius.small)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
