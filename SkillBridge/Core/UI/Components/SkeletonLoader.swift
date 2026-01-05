//
//  SkeletonLoader.swift
//  SkillBridge
//
//  Skeleton Loader Component for better UX
//

import SwiftUI

struct SkeletonLoader: View {
    @State private var isAnimating = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: AppCornerRadius.medium)
            .fill(
                LinearGradient(
                    colors: [
                        AppColors.surface,
                        AppColors.surface.opacity(0.6),
                        AppColors.surface
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .shimmer(isAnimating: isAnimating)
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false)
                ) {
                    isAnimating = true
                }
            }
    }
}

struct SkeletonCard: View {
    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                SkeletonLoader()
                    .frame(height: 20)
                SkeletonLoader()
                    .frame(height: 16)
                SkeletonLoader()
                    .frame(height: 16)
                    .frame(width: 100)
            }
        }
    }
}

extension View {
    func shimmer(isAnimating: Bool) -> some View {
        self.modifier(ShimmerModifier(isAnimating: isAnimating))
    }
}

struct ShimmerModifier: ViewModifier {
    var isAnimating: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color.white.opacity(0.3),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 2)
                    .offset(x: isAnimating ? geometry.size.width : -geometry.size.width)
                }
            )
            .clipped()
    }
}
