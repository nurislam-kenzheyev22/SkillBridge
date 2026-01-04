//
//  Card.swift
//  SkillBridge
//
//  Card Component
//

import SwiftUI

struct Card<Content: View>: View {
    let content: Content
    var padding: CGFloat = AppSpacing.md
    
    init(padding: CGFloat = AppSpacing.md, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(AppColors.surfaceElevated)
            .cornerRadius(AppCornerRadius.large)
            .shadow(
                color: AppShadows.medium.color,
                radius: AppShadows.medium.radius,
                x: AppShadows.medium.x,
                y: AppShadows.medium.y
            )
    }
}
