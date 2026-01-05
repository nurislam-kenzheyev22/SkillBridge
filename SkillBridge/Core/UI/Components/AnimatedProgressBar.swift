//
//  AnimatedProgressBar.swift
//  SkillBridge
//
//  Animated Progress Bar Component
//

import SwiftUI

struct AnimatedProgressBar: View {
    let progress: Double // 0.0 to 1.0
    let height: CGFloat
    let animated: Bool
    @State private var animatedProgress: Double = 0
    
    init(progress: Double, height: CGFloat = 8, animated: Bool = true) {
        self.progress = progress
        self.height = height
        self.animated = animated
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 4)
                    .fill(AppColors.surface)
                    .frame(height: height)
                
                // Progress
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryLight],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * CGFloat(animated ? animatedProgress : progress), height: height)
                    .animation(animated ? .spring(response: 0.6, dampingFraction: 0.8) : nil, value: animatedProgress)
            }
        }
        .frame(height: height)
        .onAppear {
            if animated {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    animatedProgress = progress
                }
            } else {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { oldValue, newValue in
            if animated {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    animatedProgress = newValue
                }
            } else {
                animatedProgress = newValue
            }
        }
    }
}
