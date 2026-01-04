//
//  MockData.swift
//  SkillBridge
//
//  Comprehensive Mock data for full demo - IITU iOS Developer example
//

import Foundation

struct MockData {
    // MARK: - User Mock Data
    static let mockUser = User(
        id: UUID(),
        email: "student@iitu.kz",
        name: "Nurislam Kenzheyev",
        role: .student
    )
    
    // MARK: - Skills Mock Data (with fixed UUIDs)
    static let swiftSkillId = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
    static let swiftUISkillId = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
    static let uikitSkillId = UUID(uuidString: "00000000-0000-0000-0000-000000000003")!
    static let xcodeSkillId = UUID(uuidString: "00000000-0000-0000-0000-000000000004")!
    static let gitSkillId = UUID(uuidString: "00000000-0000-0000-0000-000000000005")!
    static let restApiSkillId = UUID(uuidString: "00000000-0000-0000-0000-000000000006")!
    static let coreDataSkillId = UUID(uuidString: "00000000-0000-0000-0000-000000000007")!
    static let combineSkillId = UUID(uuidString: "00000000-0000-0000-0000-000000000008")!
    static let mvvmSkillId = UUID(uuidString: "00000000-0000-0000-0000-000000000009")!
    static let unitTestingSkillId = UUID(uuidString: "00000000-0000-0000-0000-000000000010")!
    static let cicdSkillId = UUID(uuidString: "00000000-0000-0000-0000-000000000011")!
    static let appStoreSkillId = UUID(uuidString: "00000000-0000-0000-0000-000000000012")!
    static let firebaseSkillId = UUID(uuidString: "00000000-0000-0000-0000-000000000016")!
    static let alamofireSkillId = UUID(uuidString: "00000000-0000-0000-0000-000000000017")!
    static let rxswiftSkillId = UUID(uuidString: "00000000-0000-0000-0000-000000000018")!
    
    static let allSkills: [Skill] = [
        // Technical Skills
        Skill(id: swiftSkillId, name: "Swift", category: .technical),
        Skill(id: swiftUISkillId, name: "SwiftUI", category: .technical),
        Skill(id: uikitSkillId, name: "UIKit", category: .technical),
        Skill(id: xcodeSkillId, name: "Xcode", category: .technical),
        Skill(id: gitSkillId, name: "Git", category: .technical),
        Skill(id: restApiSkillId, name: "REST API", category: .technical),
        Skill(id: coreDataSkillId, name: "Core Data", category: .technical),
        Skill(id: combineSkillId, name: "Combine", category: .technical),
        Skill(id: firebaseSkillId, name: "Firebase", category: .technical),
        Skill(id: alamofireSkillId, name: "Alamofire", category: .technical),
        Skill(id: rxswiftSkillId, name: "RxSwift", category: .technical),
        
        // Missing Skills (for gap report)
        Skill(id: mvvmSkillId, name: "MVVM Architecture", category: .technical),
        Skill(id: unitTestingSkillId, name: "Unit Testing", category: .technical),
        Skill(id: cicdSkillId, name: "CI/CD", category: .technical),
        Skill(id: appStoreSkillId, name: "App Store Connect", category: .technical),
        
        // Soft Skills
        Skill(id: UUID(uuidString: "00000000-0000-0000-0000-000000000013")!, name: "Communication", category: .soft),
        Skill(id: UUID(uuidString: "00000000-0000-0000-0000-000000000014")!, name: "Teamwork", category: .soft),
        Skill(id: UUID(uuidString: "00000000-0000-0000-0000-000000000015")!, name: "Problem-solving", category: .soft)
    ]
    
    // MARK: - Gap Report Mock Data
    static func mockGapReport(userId: UUID) -> GapReport {
        let skillGaps = [
            SkillGap(
                id: UUID(),
                skillId: mvvmSkillId,
                skillName: "MVVM Architecture",
                currentLevel: 30.0,
                requiredLevel: 80.0,
                priority: .high
            ),
            SkillGap(
                id: UUID(),
                skillId: unitTestingSkillId,
                skillName: "Unit Testing",
                currentLevel: 30.0,
                requiredLevel: 80.0,
                priority: .high
            ),
            SkillGap(
                id: UUID(),
                skillId: cicdSkillId,
                skillName: "CI/CD",
                currentLevel: 30.0,
                requiredLevel: 80.0,
                priority: .high
            ),
            SkillGap(
                id: UUID(),
                skillId: appStoreSkillId,
                skillName: "App Store Connect",
                currentLevel: 30.0,
                requiredLevel: 80.0,
                priority: .high
            )
        ]
        
        return GapReport(
            id: UUID(),
            userId: userId,
            readinessScore: 65.0,
            skillGaps: skillGaps,
            generatedAt: Date()
        )
    }
    
    // MARK: - Roadmap Mock Data
    static func mockRoadmap(userId: UUID) -> Roadmap {
        let steps = [
            RoadmapStep(
                id: UUID(),
                stepOrder: 1,
                title: "Learn MVVM Architecture",
                description: "Master the Model-View-ViewModel pattern for iOS development",
                skillId: mvvmSkillId,
                courseId: nil,
                estHours: 20,
                status: .pending,
                deadline: Calendar.current.date(byAdding: .day, value: 30, to: Date())
            ),
            RoadmapStep(
                id: UUID(),
                stepOrder: 2,
                title: "Learn Unit Testing",
                description: "Write comprehensive unit tests for iOS apps using XCTest",
                skillId: unitTestingSkillId,
                courseId: nil,
                estHours: 15,
                status: .pending,
                deadline: Calendar.current.date(byAdding: .day, value: 45, to: Date())
            ),
            RoadmapStep(
                id: UUID(),
                stepOrder: 3,
                title: "Setup CI/CD Pipeline",
                description: "Configure continuous integration and deployment for iOS projects",
                skillId: cicdSkillId,
                courseId: nil,
                estHours: 10,
                status: .pending,
                deadline: Calendar.current.date(byAdding: .day, value: 60, to: Date())
            ),
            RoadmapStep(
                id: UUID(),
                stepOrder: 4,
                title: "Master App Store Connect",
                description: "Learn how to publish and manage apps on the App Store",
                skillId: appStoreSkillId,
                courseId: nil,
                estHours: 8,
                status: .pending,
                deadline: Calendar.current.date(byAdding: .day, value: 75, to: Date())
            )
        ]
        
        return Roadmap(
            id: UUID(),
            title: "iOS Developer Career Path",
            status: .active,
            estimatedTotalHours: 53,
            steps: steps,
            createdAt: Date()
        )
    }
    
    // MARK: - Courses Mock Data (Expanded - 15+ courses)
    static let mockCourses: [Course] = [
        // Free Courses
        Course(
            id: UUID(),
            title: "iOS Development with SwiftUI",
            provider: "Apple Developer",
            description: "Complete guide to building iOS apps with SwiftUI. Learn modern iOS development patterns and best practices.",
            durationWeeks: 4,
            price: 0.0,
            currency: "USD",
            level: .intermediate,
            skills: [swiftUISkillId, mvvmSkillId],
            rating: 4.8,
            url: "https://developer.apple.com/tutorials/swiftui"
        ),
        Course(
            id: UUID(),
            title: "Swift Fundamentals",
            provider: "Apple Developer",
            description: "Master the Swift programming language from basics to advanced concepts.",
            durationWeeks: 3,
            price: 0.0,
            currency: "USD",
            level: .beginner,
            skills: [swiftSkillId],
            rating: 4.9,
            url: "https://developer.apple.com/swift"
        ),
        Course(
            id: UUID(),
            title: "Introduction to UIKit",
            provider: "Apple Developer",
            description: "Learn UIKit framework for building iOS applications with programmatic UI.",
            durationWeeks: 5,
            price: 0.0,
            currency: "USD",
            level: .beginner,
            skills: [uikitSkillId, swiftSkillId],
            rating: 4.7,
            url: "https://developer.apple.com/uikit"
        ),
        
        // Paid Courses - Beginner
        Course(
            id: UUID(),
            title: "iOS App Development for Beginners",
            provider: "Udemy",
            description: "Start your iOS development journey with this comprehensive beginner course.",
            durationWeeks: 6,
            price: 29.99,
            currency: "USD",
            level: .beginner,
            skills: [swiftSkillId, xcodeSkillId],
            rating: 4.5,
            url: "https://udemy.com/ios-beginner"
        ),
        Course(
            id: UUID(),
            title: "Git & GitHub for iOS Developers",
            provider: "Coursera",
            description: "Learn version control with Git and GitHub for iOS projects.",
            durationWeeks: 2,
            price: 39.99,
            currency: "USD",
            level: .beginner,
            skills: [gitSkillId],
            rating: 4.6,
            url: "https://coursera.org/git-ios"
        ),
        
        // Paid Courses - Intermediate
        Course(
            id: UUID(),
            title: "Unit Testing in iOS",
            provider: "Udemy",
            description: "Learn how to write effective unit tests for iOS applications using XCTest framework.",
            durationWeeks: 2,
            price: 49.99,
            currency: "USD",
            level: .intermediate,
            skills: [unitTestingSkillId],
            rating: 4.6,
            url: "https://udemy.com/ios-unit-testing"
        ),
        Course(
            id: UUID(),
            title: "MVVM Architecture in iOS",
            provider: "Pluralsight",
            description: "Master the MVVM pattern for building scalable iOS applications.",
            durationWeeks: 3,
            price: 59.99,
            currency: "USD",
            level: .intermediate,
            skills: [mvvmSkillId, swiftSkillId],
            rating: 4.7,
            url: "https://pluralsight.com/mvvm-ios"
        ),
        Course(
            id: UUID(),
            title: "REST API Integration in iOS",
            provider: "Udemy",
            description: "Learn how to integrate REST APIs in iOS apps using URLSession and Codable.",
            durationWeeks: 2,
            price: 44.99,
            currency: "USD",
            level: .intermediate,
            skills: [restApiSkillId, swiftSkillId],
            rating: 4.5,
            url: "https://udemy.com/rest-api-ios"
        ),
        Course(
            id: UUID(),
            title: "Core Data Mastery",
            provider: "Ray Wenderlich",
            description: "Complete guide to Core Data for persistent storage in iOS apps.",
            durationWeeks: 4,
            price: 69.99,
            currency: "USD",
            level: .intermediate,
            skills: [coreDataSkillId],
            rating: 4.8,
            url: "https://raywenderlich.com/core-data"
        ),
        Course(
            id: UUID(),
            title: "Combine Framework Deep Dive",
            provider: "Pluralsight",
            description: "Master reactive programming with Combine framework in iOS.",
            durationWeeks: 3,
            price: 54.99,
            currency: "USD",
            level: .intermediate,
            skills: [combineSkillId],
            rating: 4.6,
            url: "https://pluralsight.com/combine-ios"
        ),
        Course(
            id: UUID(),
            title: "Firebase for iOS",
            provider: "Udemy",
            description: "Build real-time iOS apps with Firebase backend services.",
            durationWeeks: 3,
            price: 49.99,
            currency: "USD",
            level: .intermediate,
            skills: [firebaseSkillId],
            rating: 4.7,
            url: "https://udemy.com/firebase-ios"
        ),
        
        // Paid Courses - Advanced
        Course(
            id: UUID(),
            title: "CI/CD for iOS",
            provider: "Coursera",
            description: "Setup continuous integration and deployment pipelines for iOS projects using Fastlane and GitHub Actions.",
            durationWeeks: 3,
            price: 79.99,
            currency: "USD",
            level: .advanced,
            skills: [cicdSkillId, gitSkillId],
            rating: 4.7,
            url: "https://coursera.org/ios-cicd"
        ),
        Course(
            id: UUID(),
            title: "Advanced iOS Architecture",
            provider: "Ray Wenderlich",
            description: "Learn advanced architectural patterns and best practices for large-scale iOS apps.",
            durationWeeks: 5,
            price: 89.99,
            currency: "USD",
            level: .advanced,
            skills: [mvvmSkillId, swiftSkillId],
            rating: 4.9,
            url: "https://raywenderlich.com/ios-architecture"
        ),
        Course(
            id: UUID(),
            title: "App Store Connect & Publishing",
            provider: "Udemy",
            description: "Complete guide to publishing iOS apps on the App Store, including App Store Connect setup and submission process.",
            durationWeeks: 2,
            price: 39.99,
            currency: "USD",
            level: .advanced,
            skills: [appStoreSkillId],
            rating: 4.5,
            url: "https://udemy.com/app-store-connect"
        ),
        Course(
            id: UUID(),
            title: "Alamofire Networking",
            provider: "Pluralsight",
            description: "Master Alamofire for elegant networking in iOS applications.",
            durationWeeks: 2,
            price: 49.99,
            currency: "USD",
            level: .advanced,
            skills: [alamofireSkillId, restApiSkillId],
            rating: 4.6,
            url: "https://pluralsight.com/alamofire"
        ),
        Course(
            id: UUID(),
            title: "RxSwift Reactive Programming",
            provider: "Ray Wenderlich",
            description: "Learn reactive programming with RxSwift for iOS development.",
            durationWeeks: 4,
            price: 79.99,
            currency: "USD",
            level: .advanced,
            skills: [rxswiftSkillId],
            rating: 4.8,
            url: "https://raywenderlich.com/rxswift"
        )
    ]
    
    // MARK: - Universities
    static let universities = ["IITU", "KBTU", "KazNU", "Satbayev University", "KIMEP", "Narxoz", "KazGUU"]
    
    // MARK: - Programs
    static let programs = [
        "Software Engineering",
        "Computer Science",
        "Information Systems",
        "Data Science",
        "AI",
        "Cybersecurity",
        "Web Development"
    ]
    
    // MARK: - Target Roles
    static let targetRoles = [
        "iOS Developer",
        "Android Developer",
        "Full-stack Developer",
        "Data Scientist",
        "ML Engineer",
        "Backend Developer",
        "DevOps Engineer",
        "QA Engineer"
    ]
}
