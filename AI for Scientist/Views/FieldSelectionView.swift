//
//  FieldSelectionView.swift
//  AI for Scientist
//
//  View for selecting research fields
//

import SwiftUI

struct FieldSelectionView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @Environment(\.dismiss) var dismiss

    @State private var selectedFields: Set<UUID> = []

    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerSection

            // Field List
            List {
                ForEach(ResearchField.predefinedFields) { field in
                    FieldRowView(
                        field: field,
                        isSelected: selectedFields.contains(field.id)
                    ) {
                        toggleField(field)
                    }
                }
            }
            .listStyle(.insetGrouped)

            // Save Button
            Button(action: saveFields) {
                Text("Save Selection")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedFields.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(10)
            }
            .disabled(selectedFields.isEmpty)
            .padding()
        }
        .navigationTitle("Research Fields")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadSelectedFields()
        }
    }

    // MARK: - View Components

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select Your Research Fields")
                .font(.title2)
                .fontWeight(.bold)

            Text("Choose one or more fields to receive personalized literature recommendations")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.blue.opacity(0.1))
    }

    // MARK: - Actions

    private func toggleField(_ field: ResearchField) {
        if selectedFields.contains(field.id) {
            selectedFields.remove(field.id)
        } else {
            selectedFields.insert(field.id)
        }
    }

    private func saveFields() {
        let fields = ResearchField.predefinedFields.filter { selectedFields.contains($0.id) }
        mainViewModel.updatePreferredFields(fields)
        dismiss()
    }

    private func loadSelectedFields() {
        selectedFields = Set(mainViewModel.userProfile.preferredFields.map { $0.id })
    }
}

// MARK: - Field Row View

struct FieldRowView: View {
    let field: ResearchField
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                // Checkmark
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray)
                    .font(.title3)

                // Field Info
                VStack(alignment: .leading, spacing: 5) {
                    Text(field.name)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(field.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)

                    // Keywords
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 5) {
                            ForEach(Array(field.keywords.prefix(3)), id: \.self) { keyword in
                                Text(keyword)
                                    .font(.caption2)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(4)
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding(.vertical, 5)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationView {
        FieldSelectionView()
            .environmentObject(MainViewModel())
    }
}
