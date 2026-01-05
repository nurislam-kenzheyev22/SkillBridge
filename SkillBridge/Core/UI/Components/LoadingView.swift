//
//  LoadingView.swift
//  SkillBridge
//
//  Reusable loading indicator following UI/UX best practices
//

import SwiftUI

/// Loading view component with accessibility support
struct LoadingView: View {
    let message: String?
    let style: LoadingStyle
    
    enum LoadingStyle {
        case spinner
        case progress
        case skeleton
    }
    
    init(message: String? = nil, style: LoadingStyle = .spinner) {
        self.message = message
        self.style = style
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            switch style {
            case .spinner:
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(AppColors.primary)
            case .progress:
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(AppColors.primary)
            case .skeleton:
                SkeletonView()
            }
            
            if let message = message {
                Text(message)
                    .font(AppFonts.subheadline)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(AppSpacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.1))
        .accessibilityLabel(message ?? "Loading")
        .accessibilityHint("Please wait while content is loading")
    }
}

/// Skeleton loading view for better UX
struct SkeletonView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            ForEach(0..<3) { _ in
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .fill(AppColors.surface)
                    .frame(height: 60)
                    .opacity(isAnimating ? 0.5 : 1.0)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}
