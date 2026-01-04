//
//  GapReportViewModel.swift
//  SkillBridge
//
//  ViewModel for Gap Report - Clean Code & SOLID principles
//

import Foundation
import SwiftUI

class GapReportViewModel: ObservableObject {
    @Published var gapReport: GapReport?
    @Published var isLoading: Bool = false
    @Published var error: AppError?
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    
    @MainActor
    func fetchGapReport(userId: UUID) async {
        isLoading = true
        error = nil
        
        do {
            gapReport = try await apiService.getGapReport(userId: userId)
        } catch {
            if let networkError = error as? NetworkError {
                self.error = .networkError(networkError)
            } else {
                self.error = .unknown(error)
            }
        }
        
        isLoading = false
    }
}
