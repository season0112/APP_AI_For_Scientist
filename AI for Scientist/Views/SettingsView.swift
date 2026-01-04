//
//  SettingsView.swift
//  AI for Scientist
//
//  Settings and preferences view
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var mainViewModel: MainViewModel

    @State private var notificationEnabled: Bool = true
    @State private var selectedFrequency: NotificationFrequency = .weekly
    @State private var showFieldSelection = false

    var body: some View {
        NavigationView {
            List {
                // Research Fields Section
                Section("Research Preferences") {
                    Button(action: { showFieldSelection = true }) {
                        HStack {
                            Text("Research Fields")
                            Spacer()
                            Text("\(mainViewModel.userProfile.preferredFields.count) selected")
                                .foregroundColor(.secondary)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }

                    if !mainViewModel.userProfile.preferredFields.isEmpty {
                        ForEach(mainViewModel.userProfile.preferredFields) { field in
                            HStack {
                                Text(field.name)
                                    .font(.subheadline)
                                Spacer()
                            }
                        }
                    }
                }

                // Notifications Section
                Section("Notifications") {
                    Toggle("Enable Notifications", isOn: $notificationEnabled)
                        .onChange(of: notificationEnabled) { _ in
                            updateNotificationSettings()
                        }

                    if notificationEnabled {
                        Picker("Frequency", selection: $selectedFrequency) {
                            ForEach(NotificationFrequency.allCases, id: \.self) { frequency in
                                Text(frequency.rawValue).tag(frequency)
                            }
                        }
                        .onChange(of: selectedFrequency) { _ in
                            updateNotificationSettings()
                        }
                    }
                }

                // Storage Section
                Section("Storage") {
                    HStack {
                        Text("Uploaded Papers")
                        Spacer()
                        Text("\(mainViewModel.userProfile.uploadedPapers.count)")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Saved Newsletters")
                        Spacer()
                        Text("\(mainViewModel.userProfile.savedNewsletters.count)")
                            .foregroundColor(.secondary)
                    }
                }

                // About Section
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }

                    Link(destination: URL(string: "https://github.com/yourusername/ai-for-scientist")!) {
                        HStack {
                            Text("GitHub Repository")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.secondary)
                        }
                    }

                    Link(destination: URL(string: "https://arxiv.org")!) {
                        HStack {
                            Text("arXiv.org")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.secondary)
                        }
                    }
                }

                // Data Management Section
                Section("Data Management") {
                    Button(role: .destructive, action: clearAllData) {
                        Text("Clear All Data")
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showFieldSelection) {
                FieldSelectionView()
            }
            .onAppear {
                loadSettings()
            }
        }
    }

    // MARK: - Actions

    private func loadSettings() {
        notificationEnabled = mainViewModel.userProfile.notificationEnabled
        selectedFrequency = mainViewModel.userProfile.notificationFrequency
    }

    private func updateNotificationSettings() {
        mainViewModel.updateNotificationSettings(
            enabled: notificationEnabled,
            frequency: selectedFrequency
        )
    }

    private func clearAllData() {
        // Clear user profile
        mainViewModel.userProfile = UserProfile()
    }
}

#Preview {
    SettingsView()
        .environmentObject(MainViewModel())
}
