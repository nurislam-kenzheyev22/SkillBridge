//
//  OnboardingStep1View.swift
//  SkillBridge
//
//  Step 1: Profile - Clean Code, UI/UX best practices
//

import SwiftUI

struct OnboardingStep1View: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case weeklyHours
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xl) {
                // Header
                headerSection
                
                // Form
                formSection
                
                Spacer(minLength: AppSpacing.xl)
                
                // Next Button
                nextButton
            }
        }
        .keyboardDismissGesture()
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(spacing: AppSpacing.sm) {
            Text("Welcome")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.textPrimary)
                .accessibilityAddTraits(.isHeader)
            
            Text("Let's get to know you")
                .font(AppFonts.title3)
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(.top, AppSpacing.xxl)
        .padding(.bottom, AppSpacing.lg)
    }
    
    private var formSection: some View {
        VStack(spacing: AppSpacing.lg) {
            // University - Dropdown
            universityPicker
            
            // Program - Dropdown
            programPicker
            
            // Year - Dropdown
            yearPicker
            
            // Target Role - Dropdown
            targetRolePicker
            
            // Weekly Study Hours - Slider
            weeklyHoursSlider
            
            // Budget
            budgetSelector
            
            // OVZ Flag
            ovzFlagSelector
            
            // Internet Quality
            internetQualitySelector
        }
        .padding(.horizontal, AppSpacing.lg)
    }
    
    // MARK: - Picker Components
    
    private var universityPicker: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                Text("University")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                if let error = viewModel.validationErrors["university"] {
                    validationErrorView(error)
                }
            }
            
            Menu {
                ForEach(viewModel.universities, id: \.self) { university in
                    Button(university) {
                        viewModel.selectedUniversity = university
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "building.2")
                        .foregroundColor(AppColors.textSecondary)
                        .font(.system(size: 16))
                    
                    Text(viewModel.selectedUniversity.isEmpty ? "Search for your university" : viewModel.selectedUniversity)
                        .foregroundColor(viewModel.selectedUniversity.isEmpty ? AppColors.textTertiary : AppColors.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(AppColors.textSecondary)
                        .font(.system(size: 12))
                }
                .padding(AppSpacing.md)
                .background(AppColors.surface)
                .cornerRadius(AppCornerRadius.medium)
            }
        }
    }
    
    private var programPicker: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                Text("Program")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                if let error = viewModel.validationErrors["program"] {
                    validationErrorView(error)
                }
            }
            
            Menu {
                ForEach(viewModel.programs, id: \.self) { program in
                    Button(program) {
                        viewModel.selectedProgram = program
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "book")
                        .foregroundColor(AppColors.textSecondary)
                        .font(.system(size: 16))
                    
                    Text(viewModel.selectedProgram.isEmpty ? "e.g. Computer Science" : viewModel.selectedProgram)
                        .foregroundColor(viewModel.selectedProgram.isEmpty ? AppColors.textTertiary : AppColors.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(AppColors.textSecondary)
                        .font(.system(size: 12))
                }
                .padding(AppSpacing.md)
                .background(AppColors.surface)
                .cornerRadius(AppCornerRadius.medium)
            }
        }
    }
    
    private var yearPicker: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Year of Study")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)
            
            Menu {
                ForEach(viewModel.years, id: \.self) { year in
                    Button("\(year)st Year") {
                        viewModel.selectedYear = year
                    }
                }
            } label: {
                HStack {
                    Text("\(viewModel.selectedYear)st Year")
                        .foregroundColor(AppColors.textPrimary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(AppColors.textSecondary)
                }
                .padding(AppSpacing.md)
                .background(AppColors.surface)
                .cornerRadius(AppCornerRadius.medium)
            }
        }
    }
    
    private var targetRolePicker: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                Text("Target Role")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                if let error = viewModel.validationErrors["targetRole"] {
                    validationErrorView(error)
                }
            }
            
            Menu {
                ForEach(viewModel.targetRoles, id: \.self) { role in
                    Button(role) {
                        viewModel.targetRole = role
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "briefcase")
                        .foregroundColor(AppColors.textSecondary)
                        .font(.system(size: 16))
                    
                    Text(viewModel.targetRole.isEmpty ? "e.g. Software Engineer" : viewModel.targetRole)
                        .foregroundColor(viewModel.targetRole.isEmpty ? AppColors.textTertiary : AppColors.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(AppColors.textSecondary)
                        .font(.system(size: 12))
                }
                .padding(AppSpacing.md)
                .background(AppColors.surface)
                .cornerRadius(AppCornerRadius.medium)
            }
        }
    }
    
    private var weeklyHoursSlider: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                Text("Weekly Study Hours")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                Spacer()
                Text("\(viewModel.weeklyHours) hrs")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primary)
            }
            
            Slider(
                value: Binding(
                    get: { Double(viewModel.weeklyHours) },
                    set: { viewModel.weeklyHours = Int($0) }
                ),
                in: 1...40,
                step: 1
            )
            .tint(AppColors.primary)
            .accessibilityLabel("Weekly study hours")
            .accessibilityValue("\(viewModel.weeklyHours) hours")
        }
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .cornerRadius(AppCornerRadius.medium)
    }
    
    private var budgetSelector: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Budget")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)
            
            HStack(spacing: AppSpacing.sm) {
                BudgetButton(title: "Free", isSelected: viewModel.budget == "Free") {
                    viewModel.budget = "Free"
                }
                BudgetButton(title: "Low", isSelected: viewModel.budget == "Low") {
                    viewModel.budget = "Low"
                }
                BudgetButton(title: "Any", isSelected: viewModel.budget == "Any") {
                    viewModel.budget = "Any"
                }
            }
        }
    }
    
    private var ovzFlagSelector: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("OVZ Flag")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)
            
            HStack(spacing: AppSpacing.sm) {
                BudgetButton(title: "Yes", isSelected: viewModel.ovzFlag) {
                    viewModel.ovzFlag = true
                }
                BudgetButton(title: "No", isSelected: !viewModel.ovzFlag) {
                    viewModel.ovzFlag = false
                }
            }
        }
    }
    
    private var internetQualitySelector: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Internet Quality")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)
            
            HStack(spacing: AppSpacing.sm) {
                BudgetButton(title: "High", isSelected: viewModel.internetQuality == "High") {
                    viewModel.internetQuality = "High"
                }
                BudgetButton(title: "Med", isSelected: viewModel.internetQuality == "Med") {
                    viewModel.internetQuality = "Med"
                }
                BudgetButton(title: "Low", isSelected: viewModel.internetQuality == "Low") {
                    viewModel.internetQuality = "Low"
                }
            }
        }
    }
    
    private var nextButton: some View {
        PrimaryButton(
            title: "Next",
            action: { viewModel.nextStep() },
            icon: "arrow.right",
            isEnabled: viewModel.canProceedFromStep1
        )
        .padding(.horizontal, AppSpacing.lg)
        .padding(.bottom, AppSpacing.xl)
        .accessibilityLabel("Continue to next step")
        .accessibilityHint(viewModel.canProceedFromStep1 ? "All required fields are filled" : "Please fill all required fields")
    }
    
    // MARK: - Helper Views
    
    private func validationErrorView(_ message: String) -> some View {
        Text(message)
            .font(AppFonts.caption)
            .foregroundColor(AppColors.error)
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, 4)
            .background(AppColors.error.opacity(0.1))
            .cornerRadius(AppCornerRadius.small)
    }
}

// MARK: - Supporting Views

struct BudgetButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.subheadline)
                .foregroundColor(isSelected ? .white : AppColors.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.sm)
                .background(isSelected ? AppColors.primary : AppColors.surface)
                .cornerRadius(AppCornerRadius.small)
        }
        .accessibilityLabel(title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Keyboard Dismiss Extension
extension View {
    func keyboardDismissGesture() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
