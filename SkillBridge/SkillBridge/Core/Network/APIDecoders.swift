//
//  APIDecoders.swift
//  SkillBridge
//
//  Custom decoders for API responses using helper functions
//

import Foundation

// MARK: - Helper functions for API response decoding

extension Roadmap {
    static func fromAPIResponse(_ response: [String: Any]) -> Roadmap? {
        guard let idString = response["id"] as? String,
              let id = UUID(uuidString: idString),
              let title = response["title"] as? String,
              let statusString = response["status"] as? String,
              let estimatedTotalHours = response["estimatedTotalHours"] as? Int,
              let stepsArray = response["steps"] as? [[String: Any]],
              let createdAtString = response["createdAt"] as? String else {
            return nil
        }
        
        let status = RoadmapStatus(rawValue: statusString) ?? .draft
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let createdAt = formatter.date(from: createdAtString) ?? Date()
        
        let steps = stepsArray.compactMap { RoadmapStep.fromAPIResponse($0) }
        
        return Roadmap(
            id: id,
            title: title,
            status: status,
            estimatedTotalHours: estimatedTotalHours,
            steps: steps,
            createdAt: createdAt
        )
    }
}

extension RoadmapStep {
    static func fromAPIResponse(_ response: [String: Any]) -> RoadmapStep? {
        guard let idString = response["id"] as? String,
              let id = UUID(uuidString: idString),
              let stepOrder = response["stepOrder"] as? Int,
              let title = response["title"] as? String,
              let description = response["description"] as? String,
              let estHours = response["estHours"] as? Int,
              let statusString = response["status"] as? String else {
            return nil
        }
        
        let status = StepStatus(rawValue: statusString) ?? .pending
        let skillId = (response["skillId"] as? String).flatMap { UUID(uuidString: $0) }
        let courseId = (response["courseId"] as? String).flatMap { UUID(uuidString: $0) }
        
        var deadline: Date? = nil
        if let deadlineString = response["deadline"] as? String {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            deadline = formatter.date(from: deadlineString)
        }
        
        return RoadmapStep(
            id: id,
            stepOrder: stepOrder,
            title: title,
            description: description,
            skillId: skillId,
            courseId: courseId,
            estHours: estHours,
            status: status,
            deadline: deadline
        )
    }
}

extension GapReport {
    static func fromAPIResponse(_ response: [String: Any]) -> GapReport? {
        guard let idString = response["id"] as? String,
              let id = UUID(uuidString: idString),
              let userIdString = response["userId"] as? String,
              let userId = UUID(uuidString: userIdString),
              let readinessScore = response["readinessScore"] as? Double,
              let skillGapsArray = response["skillGaps"] as? [[String: Any]],
              let generatedAtString = response["generatedAt"] as? String else {
            return nil
        }
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let generatedAt = formatter.date(from: generatedAtString) ?? Date()
        
        let skillGaps = skillGapsArray.compactMap { SkillGap.fromAPIResponse($0) }
        
        return GapReport(
            id: id,
            userId: userId,
            readinessScore: readinessScore,
            skillGaps: skillGaps,
            generatedAt: generatedAt
        )
    }
}

extension SkillGap {
    static func fromAPIResponse(_ response: [String: Any]) -> SkillGap? {
        guard let idString = response["id"] as? String,
              let id = UUID(uuidString: idString),
              let skillName = response["skillName"] as? String,
              let currentLevel = response["currentLevel"] as? Double,
              let requiredLevel = response["requiredLevel"] as? Double,
              let priorityString = response["priority"] as? String else {
            return nil
        }
        
        let priority = GapPriority(rawValue: priorityString) ?? .medium
        let skillId = UUID() // Generate new UUID for skill
        
        return SkillGap(
            id: id,
            skillId: skillId,
            skillName: skillName,
            currentLevel: currentLevel,
            requiredLevel: requiredLevel,
            priority: priority
        )
    }
}

extension Course {
    static func fromAPIResponse(_ response: [String: Any]) -> Course? {
        guard let idString = response["id"] as? String,
              let id = UUID(uuidString: idString),
              let title = response["title"] as? String,
              let provider = response["provider"] as? String,
              let description = response["description"] as? String,
              let durationWeeks = response["durationWeeks"] as? Int,
              let price = response["price"] as? Double,
              let levelString = response["level"] as? String else {
            return nil
        }
        
        let level = CourseLevel(rawValue: levelString) ?? .beginner
        let rating = response["rating"] as? Double
        let url = response["url"] as? String
        
        // Handle skills - API returns array of strings, convert to UUIDs
        var skills: [UUID] = []
        if let skillsArray = response["skills"] as? [String] {
            skills = skillsArray.compactMap { _ in UUID() }
        }
        
        return Course(
            id: id,
            title: title,
            provider: provider,
            description: description,
            durationWeeks: durationWeeks,
            price: price,
            currency: "USD",
            level: level,
            skills: skills,
            rating: rating,
            url: url
        )
    }
}
