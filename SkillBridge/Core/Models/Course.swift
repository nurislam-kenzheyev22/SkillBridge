//
//  Course.swift
//  SkillBridge
//
//  Course Model
//

import Foundation

struct Course: Codable, Identifiable {
    let id: UUID
    var title: String
    var provider: String
    var description: String
    var durationWeeks: Int
    var price: Double
    var currency: String
    var level: CourseLevel
    var skills: [UUID]
    var rating: Double?
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, provider, description, durationWeeks, price, level, skills, rating, url
        case currency
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Handle UUID from string
        let idString = try container.decode(String.self, forKey: .id)
        guard let id = UUID(uuidString: idString) else {
            throw DecodingError.dataCorruptedError(forKey: .id, in: container, debugDescription: "Invalid UUID string")
        }
        self.id = id
        
        self.title = try container.decode(String.self, forKey: .title)
        self.provider = try container.decode(String.self, forKey: .provider)
        self.description = try container.decode(String.self, forKey: .description)
        self.durationWeeks = try container.decode(Int.self, forKey: .durationWeeks)
        self.price = try container.decode(Double.self, forKey: .price)
        self.currency = (try? container.decode(String.self, forKey: .currency)) ?? "USD"
        self.rating = try? container.decodeIfPresent(Double.self, forKey: .rating)
        self.url = try? container.decodeIfPresent(String.self, forKey: .url)
        
        // Handle level from string
        let levelString = try container.decode(String.self, forKey: .level)
        self.level = CourseLevel(rawValue: levelString) ?? .beginner
        
        // Handle skills - API returns array of strings, convert to UUIDs
        if let skillsArray = try? container.decode([String].self, forKey: .skills) {
            // Convert skill names to UUIDs (simplified - in production, map to actual skill IDs)
            self.skills = skillsArray.map { _ in UUID() }
        } else {
            self.skills = []
        }
    }
    
    init(id: UUID = UUID(),
         title: String,
         provider: String,
         description: String,
         durationWeeks: Int = 0,
         price: Double = 0.0,
         currency: String = "USD",
         level: CourseLevel = .beginner,
         skills: [UUID] = [],
         rating: Double? = nil,
         url: String? = nil) {
        self.id = id
        self.title = title
        self.provider = provider
        self.description = description
        self.durationWeeks = durationWeeks
        self.price = price
        self.currency = currency
        self.level = level
        self.skills = skills
        self.rating = rating
        self.url = url
    }
}

enum CourseLevel: String, Codable, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}
