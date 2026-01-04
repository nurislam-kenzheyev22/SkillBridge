//
//  ProgressCircle.swift
//  SkillBridge
//
//  Circular Progress Indicator - 2025 Design
//

import SwiftUI

struct ProgressCircle: View {
    let progress: Double // 0.0 to 1.0
    let size: CGFloat
    let lineWidth: CGFloat
    var showPercentage: Bool = true
    var showChange: String? = nil
    
    init(progress: Double, size: CGFloat = 120, lineWidth: CGFloat = 12, showPercentage: Bool = true, showChange: String? = nil) {
        self.progress = min(max(progress, 0), 1)
        self.size = size
        self.lineWidth = lineWidth
        self.showPercentage = showPercentage
        self.showChange = showChange
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(AppColors.borderLight, lineWidth: lineWidth)
            
            // Progress circle with gradient
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        center: .center,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(270)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.8, dampingFraction: 0.7), value: progress)
            
            // Percentage text
            if showPercentage {
                VStack(spacing: 4) {
                    Text("\(Int(progress * 100))")
                        .font(.system(size: size * 0.3, weight: .bold, design: .rounded))
                        .foregroundColor(AppColors.textPrimary)
                    
                    if let change = showChange {
                        Text(change)
                            .font(.system(size: size * 0.12, weight: .semibold))
                            .foregroundColor(AppColors.success)
                    } else {
                        Text("%")
                            .font(.system(size: size * 0.15, weight: .regular))
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
        }
        .frame(width: size, height: size)
    }
}
