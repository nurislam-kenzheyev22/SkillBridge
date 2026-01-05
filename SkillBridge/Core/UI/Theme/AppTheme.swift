//
//  AppTheme.swift
//  SkillBridge
//
//  Design System 2025 - Modern Purple Theme with Dark Mode
//

import SwiftUI

// MARK: - Colors (2025 Trend - Purple Primary with Dark Mode)
struct AppColors {
    // Primary Colors - Purple Theme
    static let primary = Color(hex: "#6366F1") // Indigo/Purple
    static let primaryLight = Color(hex: "#818CF8")
    static let primaryDark = Color(hex: "#4F46E5")
    
    // Secondary Colors
    static let secondary = Color(hex: "#8B5CF6") // Purple
    static let secondaryLight = Color(hex: "#A78BFA")
    static let secondaryDark = Color(hex: "#7C3AED")
    
    // Accent Colors
    static let accent = Color(hex: "#EC4899") // Pink
    static let success = Color(hex: "#10B981") // Green
    static let warning = Color(hex: "#F59E0B") // Amber
    static let error = Color(hex: "#EF4444") // Red
    
    // MARK: - Adaptive Colors (Light/Dark Mode)
    static var background: Color {
        Color(light: "#FFFFFF", dark: "#111827")
    }
    
    static var surface: Color {
        Color(light: "#F9FAFB", dark: "#1F2937")
    }
    
    static var surfaceElevated: Color {
        Color(light: "#FFFFFF", dark: "#374151")
    }
    
    static var surfaceDark: Color {
        Color(light: "#F3F4F6", dark: "#111827")
    }
    
    // Text Colors
    static var textPrimary: Color {
        Color(light: "#111827", dark: "#F9FAFB")
    }
    
    static var textSecondary: Color {
        Color(light: "#6B7280", dark: "#D1D5DB")
    }
    
    static var textTertiary: Color {
        Color(light: "#9CA3AF", dark: "#9CA3AF")
    }
    
    static let textInverse = Color(hex: "#FFFFFF")
    
    // Border Colors
    static var border: Color {
        Color(light: "#E5E7EB", dark: "#374151")
    }
    
    static var borderLight: Color {
        Color(light: "#F3F4F6", dark: "#4B5563")
    }
    
    // Gradient Colors
    static let gradientStart = Color(hex: "#6366F1")
    static let gradientEnd = Color(hex: "#8B5CF6")
}

// MARK: - Color Extension for Adaptive Colors
extension Color {
    init(light: String, dark: String) {
        self.init(
            UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor(hex: dark)
                default:
                    return UIColor(hex: light)
                }
            }
        )
    }
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}

// MARK: - Fonts
struct AppFonts {
    static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    static let title1 = Font.system(size: 28, weight: .bold, design: .rounded)
    static let title2 = Font.system(size: 22, weight: .bold, design: .rounded)
    static let title3 = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let headline = Font.system(size: 17, weight: .semibold, design: .default)
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    static let callout = Font.system(size: 16, weight: .regular, design: .default)
    static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
    static let footnote = Font.system(size: 13, weight: .regular, design: .default)
    static let caption = Font.system(size: 12, weight: .regular, design: .default)
}

// MARK: - Spacing
struct AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Corner Radius
struct AppCornerRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let xlarge: CGFloat = 24
    static let round: CGFloat = 999
}

// MARK: - Shadows
struct AppShadows {
    static let small = Shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    static let medium = Shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    static let large = Shadow(color: .black.opacity(0.15), radius: 16, x: 0, y: 8)
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}
