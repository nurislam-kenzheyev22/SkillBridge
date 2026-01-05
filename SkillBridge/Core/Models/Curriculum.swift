//
//  Curriculum.swift
//  SkillBridge
//
//  Curriculum Model
//

import Foundation

struct Curriculum: Codable, Identifiable {
    let id: UUID
    var title: String
    var status: CurriculumStatus
    var source: CurriculumSource
    var modules: [CurriculumModule]
    var createdAt: Date
    
    init(id: UUID = UUID(),
         title: String,
         status: CurriculumStatus = .pending,
         source: CurriculumSource,
         modules: [CurriculumModule] = [],
         createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.status = status
        self.source = source
        self.modules = modules
        self.createdAt = createdAt
    }
}

struct CurriculumModule: Codable, Identifiable {
    let id: UUID
    var title: String
    var description: String
    var hoursEstimate: Int
    var orderIdx: Int
    
    init(id: UUID = UUID(),
         title: String,
         description: String,
         hoursEstimate: Int = 0,
         orderIdx: Int = 0) {
        self.id = id
        self.title = title
        self.description = description
        self.hoursEstimate = hoursEstimate
        self.orderIdx = orderIdx
    }
}

enum CurriculumStatus: String, Codable {
    case pending = "Pending"
    case parsing = "Parsing"
    case completed = "Completed"
    case failed = "Failed"
}

enum CurriculumSource: String, Codable {
    case upload = "Upload"
    case template = "Template"
    case manual = "Manual"
}
