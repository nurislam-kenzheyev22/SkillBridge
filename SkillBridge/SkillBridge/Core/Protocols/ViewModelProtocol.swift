//
//  ViewModelProtocol.swift
//  SkillBridge
//
//  Protocol for ViewModels following SOLID principles
//

import Foundation
import SwiftUI
import Combine

/// Base protocol for all ViewModels
/// Follows Interface Segregation Principle (ISP)
protocol ViewModelProtocol: ObservableObject {
    associatedtype State
    associatedtype Action
    
    var state: State { get }
    func handle(_ action: Action)
}

/// Protocol for ViewModels that load data
protocol LoadableViewModel: ObservableObject {
    var isLoading: Bool { get set }
    var error: AppError? { get set }
    
    func load() async
    func retry() async
}

/// Protocol for ViewModels that handle validation
protocol ValidatableViewModel: ObservableObject {
    var validationErrors: [String: String] { get set }
    
    func validate() -> Bool
    func clearValidationErrors()
}
