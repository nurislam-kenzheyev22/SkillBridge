//
//  Roadmap.swift
//  SkillBridge
//
//  Roadmap Model
//

import Foundation

struct Roadmap: Codable, Identifiable {
    let id: UUID
    var title: String
    var status: RoadmapStatus
    var estimatedTotalHours: Int
    var steps: [RoadmapStep]
    var createdAt: Date
    
    var progress: Double {
        guard !steps.isEmpty else { return 0.0 }
        let completedSteps = steps.filter { $0.status == .completed }.count
        return Double(completedSteps) / Double(steps.count)
    }
    
    init(id: UUID = UUID(),
         title: String,
         status: RoadmapStatus = .draft,
         estimatedTotalHours: Int = 0,
         steps: [RoadmapStep] = [],
         createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.status = status
        self.estimatedTotalHours = estimatedTotalHours
        self.steps = steps
        self.createdAt = createdAt
    }
}

struct RoadmapStep: Codable, Identifiable {
    let id: UUID
    var stepOrder: Int
    var title: String
    var description: String
    var skillId: UUID?
    var courseId: UUID?
    var estHours: Int
    var status: StepStatus
    var deadline: Date?
    
    init(id: UUID = UUID(),
         stepOrder: Int,
         title: String,
         description: String,
         skillId: UUID? = nil,
         courseId: UUID? = nil,
         estHours: Int = 0,
         status: StepStatus = .pending,
         deadline: Date? = nil) {
        self.id = id
        self.stepOrder = stepOrder
        self.title = title
        self.description = description
        self.skillId = skillId
        self.courseId = courseId
        self.estHours = estHours
        self.status = status
        self.deadline = deadline
    }
}

enum RoadmapStatus: String, Codable {
    case draft = "Draft"
    case active = "Active"
    case paused = "Paused"
    case completed = "Completed"
}

enum StepStatus: String, Codable {
    case pending = "Pending"
    case inProgress = "In Progress"
    case completed = "Completed"
    case skipped = "Skipped"
}
