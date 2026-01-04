//
//  OnboardingStep3View.swift
//  SkillBridge
//
//  Step 3: Curriculum Upload - 2025 Design
//

import SwiftUI
import UniformTypeIdentifiers

struct OnboardingStep3View: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let dismiss: DismissAction
    @State private var showDocumentPicker = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    viewModel.previousStep()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(AppColors.textPrimary)
                        .font(.system(size: 18, weight: .semibold))
                }
                
                Text("Add Curriculum")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
            
            // Progress dots
            HStack(spacing: 6) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(index == 2 ? AppColors.primary : AppColors.border)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom, AppSpacing.lg)
            
            ScrollView {
                VStack(spacing: AppSpacing.xl) {
                    // Header Text
                    Text("How would you like to add your curriculum?")
                        .font(AppFonts.title3)
                        .foregroundColor(AppColors.textPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.xl)
                    
                    // Options
                    VStack(spacing: AppSpacing.md) {
                        // Upload PDF
                        UploadOptionCard(
                            icon: "doc.fill",
                            iconColor: AppColors.primary,
                            title: "Upload curriculum file",
                            subtitle: "PDF format"
                        ) {
                            Task { @MainActor in
                                viewModel.uploadOption = .upload
                            }
                            showDocumentPicker = true
                        }
                        
                        // Manual Input
                        UploadOptionCard(
                            icon: "pencil",
                            iconColor: AppColors.secondary,
                            title: "Paste module descriptions manually",
                            subtitle: "Enter text directly"
                        ) {
                            Task { @MainActor in
                                viewModel.uploadOption = .manual
                            }
                        }
                        
                        // Template
                        UploadOptionCard(
                            icon: "list.bullet",
                            iconColor: AppColors.accent,
                            title: "Select preloaded university/program",
                            subtitle: "Choose from templates"
                        ) {
                            Task { @MainActor in
                                viewModel.uploadOption = .template
                            }
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    
                    if viewModel.selectedFile != nil {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(AppColors.success)
                            Text("File selected successfully")
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.textPrimary)
                        }
                        .padding()
                        .background(AppColors.success.opacity(0.1))
                        .cornerRadius(AppCornerRadius.medium)
                        .padding(.horizontal, AppSpacing.lg)
                    }
                    
                    Spacer(minLength: AppSpacing.xl)
                    
                    // Continue Button
                    PrimaryButton(
                        title: "Continue",
                        action: {
                            // Complete onboarding and dismiss
                            viewModel.completeOnboarding()
                            dismiss()
                        },
                        icon: "checkmark.circle.fill"
                    )
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.xl)
                }
            }
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker(documentURL: Binding(
                get: { viewModel.selectedFile },
                set: { newValue in
                    Task { @MainActor in
                        viewModel.selectedFile = newValue
                    }
                }
            ))
        }
    }
}

struct UploadOptionCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(subtitle)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(AppColors.textTertiary)
            }
            .padding(AppSpacing.md)
            .background(AppColors.surfaceElevated)
            .cornerRadius(AppCornerRadius.large)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var documentURL: URL?
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            Task { @MainActor in
                parent.documentURL = urls.first
            }
            parent.dismiss()
        }
    }
}
