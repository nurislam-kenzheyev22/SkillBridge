//
//  CourseCatalogView.swift
//  SkillBridge
//
//  Course Catalog - Clean Code, UI/UX best practices with Real-time Search
//

import SwiftUI

struct CourseCatalogView: View {
    @StateObject private var viewModel = CourseCatalogViewModel()
    @FocusState private var isSearchFocused: Bool
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Search Bar with Autocomplete
                VStack(spacing: 0) {
                    HStack(spacing: AppSpacing.sm) {
                        // Search Field
                        HStack(spacing: AppSpacing.sm) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(AppColors.textSecondary)
                                .font(.system(size: 16))
                            
                            TextField("Search courses...", text: $viewModel.searchText)
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.textPrimary)
                                .focused($isSearchFocused)
                                .onChange(of: viewModel.searchText) { oldValue, newValue in
                                    // Real-time search - results update immediately
                                    viewModel.updateSearchResults()
                                }
                            
                            if !viewModel.searchText.isEmpty {
                                Button(action: {
                                    viewModel.searchText = ""
                                    isSearchFocused = false
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(AppColors.textTertiary)
                                        .font(.system(size: 16))
                                }
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        .padding(.vertical, AppSpacing.sm)
                        .background(AppColors.surface)
                        .cornerRadius(AppCornerRadius.medium)
                        
                        // Filter Button
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                viewModel.showFilters.toggle()
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(viewModel.hasActiveFilters ? AppColors.primary : AppColors.surface)
                                    .frame(width: 44, height: 44)
                                
                                Image(systemName: "slider.horizontal.3")
                                    .foregroundColor(viewModel.hasActiveFilters ? .white : AppColors.textPrimary)
                                    .font(.system(size: 18))
                            }
                            .overlay(
                                Circle()
                                    .fill(AppColors.error)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 8, y: -8)
                                    .opacity(viewModel.hasActiveFilters ? 1 : 0)
                            )
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.md)
                    
                    // Autocomplete Suggestions (appears when typing)
                    if isSearchFocused && !viewModel.searchText.isEmpty && !viewModel.autocompleteSuggestions.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppSpacing.sm) {
                                ForEach(viewModel.autocompleteSuggestions.prefix(5), id: \.self) { suggestion in
                                    AutocompleteChip(suggestion: suggestion) {
                                        viewModel.searchText = suggestion
                                        isSearchFocused = false
                                    }
                                }
                            }
                            .padding(.horizontal, AppSpacing.lg)
                        }
                        .padding(.top, AppSpacing.sm)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    // Quick Search Tags (popular searches)
                    if viewModel.searchText.isEmpty && !isSearchFocused {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppSpacing.sm) {
                                Text("Popular:")
                                    .font(AppFonts.caption)
                                    .foregroundColor(AppColors.textSecondary)
                                
                                ForEach(["Swift", "iOS", "SwiftUI", "Free", "Beginner"], id: \.self) { tag in
                                    QuickSearchTag(tag: tag) {
                                        viewModel.searchText = tag
                                        isSearchFocused = true
                                    }
                                }
                            }
                            .padding(.horizontal, AppSpacing.lg)
                        }
                        .padding(.top, AppSpacing.sm)
                    }
                }
                
                // Filters Panel
                if viewModel.showFilters {
                    FiltersPanel(viewModel: viewModel)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                // Results Count
                if !viewModel.searchText.isEmpty || viewModel.hasActiveFilters {
                    HStack {
                        Text("\(viewModel.filteredCourses.count) \(viewModel.filteredCourses.count == 1 ? "course" : "courses") found")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.textSecondary)
                        Spacer()
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.sm)
                }
                
                // Content
                if viewModel.isLoading {
                    LoadingView(message: "Loading courses...")
                } else if viewModel.filteredCourses.isEmpty {
                    EmptyStateView(
                        icon: "book.closed.fill",
                        title: viewModel.searchText.isEmpty ? "No courses available" : "No courses found",
                        message: viewModel.searchText.isEmpty ? "Check back later for new courses" : "Try a different search term or adjust filters"
                    )
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: AppSpacing.md) {
                            ForEach(viewModel.filteredCourses) { course in
                                CourseCard(
                                    course: course,
                                    isFavorite: viewModel.isFavorite(courseId: course.id),
                                    onFavoriteToggle: {
                                        viewModel.toggleFavorite(courseId: course.id)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.vertical, AppSpacing.md)
                    }
                    .refreshable {
                        await viewModel.fetchCourses()
                    }
                }
            }
        }
        .navigationTitle("Course Catalog")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.fetchCourses()
        }
        .alert("Error", isPresented: .constant(viewModel.error != nil)) {
            Button("Retry") {
                Task {
                    await viewModel.fetchCourses()
                }
            }
            Button("Dismiss", role: .cancel) {
                viewModel.error = nil
            }
        } message: {
            if let error = viewModel.error {
                Text(error.userFriendlyMessage)
            }
        }
    }
}

// MARK: - Autocomplete Chip
struct AutocompleteChip: View {
    let suggestion: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 12))
                Text(suggestion)
                    .font(AppFonts.subheadline)
            }
            .foregroundColor(AppColors.primary)
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .background(AppColors.primary.opacity(0.1))
            .cornerRadius(AppCornerRadius.small)
        }
    }
}

// MARK: - Quick Search Tag
struct QuickSearchTag: View {
    let tag: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(tag)
                .font(AppFonts.subheadline)
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(AppColors.surface)
                .cornerRadius(AppCornerRadius.small)
        }
    }
}

// MARK: - Filters Panel
struct FiltersPanel: View {
    @ObservedObject var viewModel: CourseCatalogViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            // Price Filter
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Price")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppSpacing.sm) {
                        ForEach(PriceFilter.allCases, id: \.self) { filter in
                            FilterChip(
                                title: filter.rawValue,
                                isSelected: viewModel.selectedPriceFilter == filter
                            ) {
                                viewModel.selectedPriceFilter = filter
                            }
                        }
                    }
                }
            }
            
            // Duration Filter
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Duration")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppSpacing.sm) {
                        ForEach(DurationFilter.allCases, id: \.self) { filter in
                            FilterChip(
                                title: filter.rawValue,
                                isSelected: viewModel.selectedDurationFilter == filter
                            ) {
                                viewModel.selectedDurationFilter = filter
                            }
                        }
                    }
                }
            }
            
            // Level Filter
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Level")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppSpacing.sm) {
                        FilterChip(
                            title: "All",
                            isSelected: viewModel.selectedLevelFilter == nil
                        ) {
                            viewModel.selectedLevelFilter = nil
                        }
                        
                        ForEach(CourseLevel.allCases, id: \.self) { level in
                            FilterChip(
                                title: level.rawValue,
                                isSelected: viewModel.selectedLevelFilter == level
                            ) {
                                viewModel.selectedLevelFilter = level
                            }
                        }
                    }
                }
            }
            
            // Clear Filters
            if viewModel.hasActiveFilters {
                Button(action: {
                    viewModel.clearFilters()
                }) {
                    HStack {
                        Image(systemName: "xmark.circle.fill")
                        Text("Clear Filters")
                    }
                    .font(AppFonts.subheadline)
                    .foregroundColor(AppColors.error)
                }
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .cornerRadius(AppCornerRadius.medium)
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, AppSpacing.sm)
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.subheadline)
                .foregroundColor(isSelected ? .white : AppColors.textPrimary)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(isSelected ? AppColors.primary : AppColors.surfaceElevated)
                .cornerRadius(AppCornerRadius.small)
        }
    }
}

