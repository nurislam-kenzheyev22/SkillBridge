//
//  APIServiceProtocol.swift
//  SkillBridge
//
//  Protocol for API Service - Dependency Inversion Principle
//

import Foundation

/// Protocol for API Service following Dependency Inversion Principle
protocol APIServiceProtocol {
    func getCurrentUser() async throws -> User
    func getGapReport(userId: UUID) async throws -> GapReport
    func generateRoadmap(userId: UUID) async throws -> Roadmap
    func getCourses() async throws -> [Course]
    func login(email: String, password: String) async throws -> LoginResponse
    func register(email: String, password: String, name: String) async throws -> LoginResponse
    func uploadCurriculum(fileURL: URL) async throws -> Curriculum
}
