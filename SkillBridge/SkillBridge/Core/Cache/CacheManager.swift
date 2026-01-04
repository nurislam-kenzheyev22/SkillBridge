//
//  CacheManager.swift
//  SkillBridge
//
//  Simple in-memory cache for faster data access
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    
    private var cache: [String: Any] = [:]
    private let cacheQueue = DispatchQueue(label: "com.skillbridge.cache", attributes: .concurrent)
    
    private init() {}
    
    // MARK: - Generic Cache Methods
    
    func set<T>(_ value: T, forKey key: String) {
        cacheQueue.async(flags: .barrier) {
            self.cache[key] = value
        }
    }
    
    func get<T>(forKey key: String) -> T? {
        return cacheQueue.sync {
            return cache[key] as? T
        }
    }
    
    func remove(forKey key: String) {
        cacheQueue.async(flags: .barrier) {
            self.cache.removeValue(forKey: key)
        }
    }
    
    func clear() {
        cacheQueue.async(flags: .barrier) {
            self.cache.removeAll()
        }
    }
    
    // MARK: - Specific Cache Keys
    
    struct CacheKeys {
        static let currentUser = "current_user"
        static let courses = "courses"
        static let gapReport = "gap_report_"
        static let roadmap = "roadmap_"
    }
}
