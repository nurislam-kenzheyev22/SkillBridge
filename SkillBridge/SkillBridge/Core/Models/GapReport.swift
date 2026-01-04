//
//  GapReport.swift
//  SkillBridge
//
//  Gap Report Model
//

import Foundation

struct GapReport: Codable, Identifiable {
    let id: UUID
    var userId: UUID
    var readinessScore: Double
    var skillGaps: [SkillGap]
    var generatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, userId, readinessScore, skillGaps, generatedAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Handle UUID from string
        let idString = try container.decode(String.self, forKey: .id)
        guard let id = UUID(uuidString: idString) else {
            throw DecodingError.dataCorruptedError(forKey: .id, in: container, debugDescription: "Invalid UUID string")
        }
        self.id = id
        
        let userIdString = try container.decode(String.self, forKey: .userId)
        guard let userId = UUID(uuidString: userIdString) else {
            throw DecodingError.dataCorruptedError(forKey: .userId, in: container, debugDescription: "Invalid UUID string")
        }
        self.userId = userId
        
        self.readinessScore = try container.decode(Double.self, forKey: .readinessScore)
        self.skillGaps = try container.decode([SkillGap].self, forKey: .skillGaps)
        
        // Handle date from string
        let dateString = try container.decode(String.self, forKey: .generatedAt)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: dateString) {
            self.generatedAt = date
        } else {
            // Fallback to simple date format
            let simpleFormatter = DateFormatter()
            simpleFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            self.generatedAt = simpleFormatter.date(from: dateString) ?? Date()
        }
    }
    
    init(id: UUID = UUID(),
         userId: UUID,
         readinessScore: Double = 0.0,
         skillGaps: [SkillGap] = [],
         generatedAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.readinessScore = readinessScore
        self.skillGaps = skillGaps
        self.generatedAt = generatedAt
    }
}

struct SkillGap: Codable, Identifiable {
    let id: UUID
    var skillId: UUID
    var skillName: String
    var currentLevel: Double
    var requiredLevel: Double
    var gap: Double {
        return max(0, requiredLevel - currentLevel)
    }
    var priority: GapPriority
    
    enum CodingKeys: String, CodingKey {
        case id, skillName, currentLevel, requiredLevel, priority
        case skillId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Handle UUID from string
        let idString = try container.decode(String.self, forKey: .id)
        guard let id = UUID(uuidString: idString) else {
            throw DecodingError.dataCorruptedError(forKey: .id, in: container, debugDescription: "Invalid UUID string")
        }
        self.id = id
        
        // skillId is optional in API - generate if not present
        if let skillIdString = try? container.decode(String.self, forKey: .skillId),
           let skillId = UUID(uuidString: skillIdString) {
            self.skillId = skillId
        } else {
            self.skillId = UUID() // Generate new UUID if not provided
        }
        
        self.skillName = try container.decode(String.self, forKey: .skillName)
        self.currentLevel = try container.decode(Double.self, forKey: .currentLevel)
        self.requiredLevel = try container.decode(Double.self, forKey: .requiredLevel)
        
        // Handle priority from string
        let priorityString = try container.decode(String.self, forKey: .priority)
        self.priority = GapPriority(rawValue: priorityString) ?? .medium
    }
    
    init(id: UUID = UUID(),
         skillId: UUID,
         skillName: String,
         currentLevel: Double,
         requiredLevel: Double,
         priority: GapPriority = .medium) {
        self.id = id
        self.skillId = skillId
        self.skillName = skillName
        self.currentLevel = currentLevel
        self.requiredLevel = requiredLevel
        self.priority = priority
    }
}

enum GapPriority: String, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}
