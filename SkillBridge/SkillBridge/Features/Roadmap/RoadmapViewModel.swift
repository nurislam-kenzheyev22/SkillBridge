//
//  RoadmapViewModel.swift
//  SkillBridge
//
//  ViewModel for Roadmap - Clean Code & SOLID principles
//

import Foundation
import SwiftUI

class RoadmapViewModel: ObservableObject {
    @Published var roadmap: Roadmap?
    @Published var isLoading: Bool = false
    @Published var error: AppError?
    
    private let apiService: APIServiceProtocol
    private let userDefaults: UserDefaults
    
    init(apiService: APIServiceProtocol = APIService.shared, userDefaults: UserDefaults = .standard) {
        self.apiService = apiService
        self.userDefaults = userDefaults
    }
    
    @MainActor
    func fetchRoadmap(userId: UUID) async {
        isLoading = true
        error = nil
        
        do {
            var fetchedRoadmap = try await apiService.generateRoadmap(userId: userId)
            
            // Load saved progress from UserDefaults
            if let savedProgress = loadSavedProgress(roadmapId: fetchedRoadmap.id) {
                // Update step statuses from saved progress
                var updatedSteps = fetchedRoadmap.steps
                for (index, step) in updatedSteps.enumerated() {
                    if let savedStatus = savedProgress[step.id] {
                        updatedSteps[index] = RoadmapStep(
                            id: step.id,
                            stepOrder: step.stepOrder,
                            title: step.title,
                            description: step.description,
                            skillId: step.skillId,
                            courseId: step.courseId,
                            estHours: step.estHours,
                            status: savedStatus,
                            deadline: step.deadline
                        )
                    }
                }
                fetchedRoadmap = Roadmap(
                    id: fetchedRoadmap.id,
                    title: fetchedRoadmap.title,
                    status: fetchedRoadmap.status,
                    estimatedTotalHours: fetchedRoadmap.estimatedTotalHours,
                    steps: updatedSteps,
                    createdAt: fetchedRoadmap.createdAt
                )
            }
            
            roadmap = fetchedRoadmap
        } catch {
            if let networkError = error as? NetworkError {
                self.error = .networkError(networkError)
            } else {
                self.error = .unknown(error)
            }
        }
        
        isLoading = false
    }
    
    @MainActor
    func markStepCompleted(stepId: UUID) {
        guard var roadmap = roadmap else { return }
        
        var updatedSteps = roadmap.steps
        if let index = updatedSteps.firstIndex(where: { $0.id == stepId }) {
            let step = updatedSteps[index]
            updatedSteps[index] = RoadmapStep(
                id: step.id,
                stepOrder: step.stepOrder,
                title: step.title,
                description: step.description,
                skillId: step.skillId,
                courseId: step.courseId,
                estHours: step.estHours,
                status: .completed,
                deadline: step.deadline
            )
            
            roadmap = Roadmap(
                id: roadmap.id,
                title: roadmap.title,
                status: roadmap.status,
                estimatedTotalHours: roadmap.estimatedTotalHours,
                steps: updatedSteps,
                createdAt: roadmap.createdAt
            )
            
            self.roadmap = roadmap
            
            // Save progress to UserDefaults
            saveProgress(roadmapId: roadmap.id, stepId: stepId, status: .completed)
        }
    }
    
    @MainActor
    func refresh(userId: UUID) async {
        await fetchRoadmap(userId: userId)
    }
    
    // MARK: - Progress Persistence
    private func saveProgress(roadmapId: UUID, stepId: UUID, status: StepStatus) {
        let key = "roadmap_progress_\(roadmapId.uuidString)"
        var progress: [String: String] = [:]
        
        if let data = userDefaults.data(forKey: key),
           let decoded = try? JSONDecoder().decode([String: String].self, from: data) {
            progress = decoded
        }
        
        progress[stepId.uuidString] = status.rawValue
        
        if let encoded = try? JSONEncoder().encode(progress) {
            userDefaults.set(encoded, forKey: key)
        }
    }
    
    private func loadSavedProgress(roadmapId: UUID) -> [UUID: StepStatus]? {
        let key = "roadmap_progress_\(roadmapId.uuidString)"
        guard let data = userDefaults.data(forKey: key),
              let progress = try? JSONDecoder().decode([String: String].self, from: data) else {
            return nil
        }
        
        var result: [UUID: StepStatus] = [:]
        for (stepIdString, statusString) in progress {
            if let stepId = UUID(uuidString: stepIdString),
               let status = StepStatus(rawValue: statusString) {
                result[stepId] = status
            }
        }
        return result
    }
}
