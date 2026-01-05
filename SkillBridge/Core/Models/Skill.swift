//
//  Skill.swift
//  SkillBridge
//
//  Skill Model
//

import Foundation

struct Skill: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var category: SkillCategory
    var description: String?
    var proficiency: ProficiencyLevel?
    
    init(id: UUID = UUID(),
         name: String,
         category: SkillCategory,
         description: String? = nil,
         proficiency: ProficiencyLevel? = nil) {
        self.id = id
        self.name = name
        self.category = category
        self.description = description
        self.proficiency = proficiency
    }
}

enum SkillCategory: String, Codable, CaseIterable {
    case technical = "Technical Skills"
    case design = "Design & UX"
    case business = "Business Skills"
    case soft = "Soft Skills"
}

enum ProficiencyLevel: String, Codable, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case expert = "Expert"
}
