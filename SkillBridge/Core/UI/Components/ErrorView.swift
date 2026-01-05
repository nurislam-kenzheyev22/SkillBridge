//
//  ErrorView.swift
//  SkillBridge
//
//  Reusable error display component following UI/UX best practices
//

import SwiftUI

/// Error view component with retry functionality
struct ErrorView: View {
    let error: AppError
    let onRetry: (() -> Void)?
    let onDismiss: (() -> Void)?
    
    init(
        error: AppError,
        onRetry: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.error = error
        self.onRetry = onRetry
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            // Error Icon
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(AppColors.error)
            
            // Error Message
            VStack(spacing: AppSpacing.sm) {
                Text("Oops! Something went wrong")
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.textPrimary)
                
                Text(error.userFriendlyMessage)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.lg)
            }
            
            // Action Buttons
            VStack(spacing: AppSpacing.md) {
                if error.isRetryable, let onRetry = onRetry {
                    PrimaryButton(
                        title: "Try Again",
                        action: onRetry,
                        icon: "arrow.clockwise"
                    )
                }
                
                if let onDismiss = onDismiss {
                    SecondaryButton(
                        title: "Dismiss",
                        action: onDismiss
                    )
                }
            }
            .padding(.horizontal, AppSpacing.lg)
        }
        .padding(AppSpacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
        .accessibilityLabel("Error: \(error.userFriendlyMessage)")
    }
}
