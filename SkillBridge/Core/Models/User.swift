//
//  User.swift
//  SkillBridge
//
//  User Model - MVVM Architecture
//

import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    var email: String
    var name: String
    var role: UserRole
    var universityId: Int?
    var programId: Int?
    var year: Int?
    var targetRole: String?
    
    enum CodingKeys: String, CodingKey {
        case id, email, name, role, universityId, programId, year, targetRole
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Handle UUID from string
        let idString = try container.decode(String.self, forKey: .id)
        guard let id = UUID(uuidString: idString) else {
            throw DecodingError.dataCorruptedError(forKey: .id, in: container, debugDescription: "Invalid UUID string")
        }
        self.id = id
        
        self.email = try container.decode(String.self, forKey: .email)
        self.name = try container.decode(String.self, forKey: .name)
        
        // Handle role from string
        let roleString = try container.decode(String.self, forKey: .role)
        self.role = UserRole(rawValue: roleString) ?? .student
        
        self.universityId = try? container.decodeIfPresent(Int.self, forKey: .universityId)
        self.programId = try? container.decodeIfPresent(Int.self, forKey: .programId)
        self.year = try? container.decodeIfPresent(Int.self, forKey: .year)
        self.targetRole = try? container.decodeIfPresent(String.self, forKey: .targetRole)
    }
    
    init(id: UUID = UUID(), 
         email: String, 
         name: String, 
         role: UserRole = .student) {
        self.id = id
        self.email = email
        self.name = name
        self.role = role
    }
}

enum UserRole: String, Codable {
    case student
    case counselor
    case admin
}
