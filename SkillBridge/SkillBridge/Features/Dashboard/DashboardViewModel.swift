//
//  DashboardViewModel.swift
//  SkillBridge
//
//  ViewModel for Dashboard - Clean Code & SOLID principles
//

import Foundation
import SwiftUI
import Combine

/// ViewModel following Single Responsibility and Dependency Inversion principles
final class DashboardViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var user: User?
    @Published var readinessScore: Double = 0.0
    @Published var gapReport: GapReport?
    @Published var roadmap: Roadmap?
    @Published var isLoading: Bool = false
    @Published var error: AppError?
    
    // MARK: - Dependencies (Dependency Inversion Principle)
    private let apiService: APIServiceProtocol
    
    // MARK: - Initialization
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    
    // MARK: - Data Loading
    @MainActor
    func loadDashboard() async {
        isLoading = true
        error = nil
        
        // Load user first (required for other requests)
        await loadUser()
        
        // Load gap report and roadmap in parallel (both depend on user)
        // Using Task for parallel execution since functions return Void
        if let userId = user?.id {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { @MainActor in
                    await self.loadGapReport(userId: userId)
                }
                
                group.addTask { @MainActor in
                    await self.loadRoadmap(userId: userId)
                }
            }
        }
        
        isLoading = false
    }
    
    // MARK: - Private Loading Methods (Single Responsibility)
    @MainActor
    private func loadUser() async {
        do {
            user = try await apiService.getCurrentUser()
        } catch {
            handleError(error)
        }
    }
    
    @MainActor
    private func loadGapReport(userId: UUID) async {
        do {
            gapReport = try await apiService.getGapReport(userId: userId)
            readinessScore = gapReport?.readinessScore ?? 0.0
        } catch {
            handleError(error)
        }
    }
    
    @MainActor
    private func loadRoadmap(userId: UUID) async {
        do {
            roadmap = try await apiService.generateRoadmap(userId: userId)
        } catch {
            handleError(error)
        }
    }
    
    // MARK: - Error Handling
    @MainActor
    private func handleError(_ error: Error) {
        if let networkError = error as? NetworkError {
            self.error = .networkError(networkError)
        } else {
            self.error = .unknown(error)
        }
    }
    
    // MARK: - Retry
    func retry() {
        Task { @MainActor in
            await loadDashboard()
        }
    }
    
    // MARK: - Refresh
    func refresh() async {
        await loadDashboard()
    }
}
