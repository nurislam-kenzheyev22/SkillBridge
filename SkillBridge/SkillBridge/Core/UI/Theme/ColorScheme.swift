//
//  ColorScheme.swift
//  SkillBridge
//
//  Dark Mode Support
//

import SwiftUI

extension AppColors {
    // Adaptive colors that work in both light and dark mode
    static var adaptiveBackground: Color {
        Color(light: .white, dark: Color(hex: "#121212"))
    }
    
    static var adaptiveSurface: Color {
        Color(light: Color(hex: "#F8F9FA"), dark: Color(hex: "#1E1E1E"))
    }
    
    static var adaptiveTextPrimary: Color {
        Color(light: Color(hex: "#212121"), dark: .white)
    }
    
    static var adaptiveTextSecondary: Color {
        Color(light: Color(hex: "#757575"), dark: Color(hex: "#B0B0B0"))
    }
}

extension Color {
    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor(light: UIColor(light), dark: UIColor(dark)))
    }
}

extension UIColor {
    convenience init(light: UIColor, dark: UIColor) {
        self.init { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? dark : light
        }
    }
}
