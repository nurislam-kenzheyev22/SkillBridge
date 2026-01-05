//
//  CourseCatalogViewModel.swift
//  SkillBridge
//
//  ViewModel for Course Catalog - Clean Code & SOLID principles with Real-time Search
//

import Foundation
import SwiftUI
import Combine

class CourseCatalogViewModel: ObservableObject {
    @Published var courses: [Course] = []
    @Published var isLoading: Bool = false
    @Published var error: AppError?
    @Published var searchText: String = "" {
        didSet {
            // Real-time search update
            updateSearchResults()
        }
    }
    
    // Filters
    @Published var selectedPriceFilter: PriceFilter = .all
    @Published var selectedDurationFilter: DurationFilter = .all
    @Published var selectedLevelFilter: CourseLevel? = nil
    @Published var showFilters: Bool = false
    
    // Favorites
    @Published var favoriteCourseIds: Set<UUID> = []
    
    // Autocomplete suggestions
    @Published var autocompleteSuggestions: [String] = []
    
    private let apiService: APIServiceProtocol
    private let userDefaults: UserDefaults
    private var cancellables = Set<AnyCancellable>()
    
    init(apiService: APIServiceProtocol = APIService.shared, userDefaults: UserDefaults = .standard) {
        self.apiService = apiService
        self.userDefaults = userDefaults
        loadFavorites()
        
        // Save favorites when changed
        $favoriteCourseIds
            .dropFirst()
            .sink { [weak self] favorites in
                self?.saveFavorites(favorites)
            }
            .store(in: &cancellables)
        
        // Update autocomplete when search text changes
        $searchText
            .debounce(for: .milliseconds(50), scheduler: RunLoop.main)
            .removeDuplicates()            .sink { [weak self] _ in
                self?.updateAutocomplete()
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func fetchCourses() async {
        isLoading = true
        error = nil
        
        do {
            courses = try await apiService.getCourses()
            updateAutocomplete()
        } catch {
            if let networkError = error as? NetworkError {
                self.error = .networkError(networkError)
            } else {
                self.error = .unknown(error)
            }
        }
        
        isLoading = false
    }
    
    // Real-time search results update
    func updateSearchResults() {
        // Results are computed in filteredCourses property
        // This triggers view update
        objectWillChange.send()
    }
    
    // Generate autocomplete suggestions based on courses
    private func updateAutocomplete() {
        guard !searchText.isEmpty else {
            autocompleteSuggestions = []
            return
        }
        
        let lowercasedSearch = searchText.lowercased()
        var suggestions: Set<String> = []
        
        // Search in course titles
        for course in courses {
            let titleWords = course.title.lowercased().components(separatedBy: " ")
            for word in titleWords {
                if word.hasPrefix(lowercasedSearch) && word.count > lowercasedSearch.count {
                    suggestions.insert(word.capitalized)
                }
            }
        }
        
        // Search in providers
        for course in courses {
            if course.provider.lowercased().hasPrefix(lowercasedSearch) {
                suggestions.insert(course.provider)
            }
        }
        
        // Search in skill-related terms
        let skillTerms = ["Swift", "iOS", "SwiftUI", "UIKit", "Xcode", "Git", "MVVM", "Testing", "CI/CD", "Firebase"]
        for term in skillTerms {
            if term.lowercased().hasPrefix(lowercasedSearch) {
                suggestions.insert(term)
            }
        }
        
        autocompleteSuggestions = Array(suggestions).sorted()
    }
    
    var filteredCourses: [Course] {
        var result = courses
        
        // Search filter (real-time)
        if !searchText.isEmpty {
            let searchLower = searchText.lowercased()
            result = result.filter { course in
                course.title.lowercased().contains(searchLower) ||
                course.description.lowercased().contains(searchLower) ||
                course.provider.lowercased().contains(searchLower) ||
                course.level.rawValue.lowercased().contains(searchLower)
            }
        }
        
        // Price filter
        switch selectedPriceFilter {
        case .all:
            break
        case .free:
            result = result.filter { $0.price == 0 }
        case .paid:
            result = result.filter { $0.price > 0 }
        case .low:
            result = result.filter { $0.price > 0 && $0.price <= 50 }
        case .medium:
            result = result.filter { $0.price > 50 && $0.price <= 100 }
        case .high:
            result = result.filter { $0.price > 100 }
        }
        
        // Duration filter
        switch selectedDurationFilter {
        case .all:
            break
        case .short:
            result = result.filter { $0.durationWeeks <= 2 }
        case .medium:
            result = result.filter { $0.durationWeeks > 2 && $0.durationWeeks <= 4 }
        case .long:
            result = result.filter { $0.durationWeeks > 4 }
        }
        
        // Level filter
        if let level = selectedLevelFilter {
            result = result.filter { $0.level == level }
        }
        
        return result
    }
    
    func toggleFavorite(courseId: UUID) {
        if favoriteCourseIds.contains(courseId) {
            favoriteCourseIds.remove(courseId)
        } else {
            favoriteCourseIds.insert(courseId)
        }
    }
    
    func isFavorite(courseId: UUID) -> Bool {
        favoriteCourseIds.contains(courseId)
    }
    
    func clearFilters() {
        selectedPriceFilter = .all
        selectedDurationFilter = .all
        selectedLevelFilter = nil
    }
    
    var hasActiveFilters: Bool {
        selectedPriceFilter != .all ||
        selectedDurationFilter != .all ||
        selectedLevelFilter != nil
    }
    
    // MARK: - Favorites Persistence
    private func loadFavorites() {
        if let data = userDefaults.data(forKey: "favorite_courses"),
           let favorites = try? JSONDecoder().decode(Set<UUID>.self, from: data) {
            favoriteCourseIds = favorites
        }
    }
    
    private func saveFavorites(_ favorites: Set<UUID>) {
        if let data = try? JSONEncoder().encode(favorites) {
            userDefaults.set(data, forKey: "favorite_courses")
        }
    }
}

// MARK: - Filter Types
enum PriceFilter: String, CaseIterable {
    case all = "All"
    case free = "Free"
    case paid = "Paid"
    case low = "Low ($0-$50)"
    case medium = "Medium ($50-$100)"
    case high = "High ($100+)"
}

enum DurationFilter: String, CaseIterable {
    case all = "All"
    case short = "Short (≤2 weeks)"
    case medium = "Medium (2-4 weeks)"
    case long = "Long (>4 weeks)"
}
