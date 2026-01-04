//
//  ContentView.swift
//  AI for Scientist
//
//  Main content view with tab navigation
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var mainViewModel: MainViewModel

    var body: some View {
        TabView(selection: $mainViewModel.selectedTab) {
            HomeView()
                .tabItem {
                    Label(AppTab.home.rawValue, systemImage: AppTab.home.systemImage)
                }
                .tag(AppTab.home)

            PDFUploadView()
                .tabItem {
                    Label(AppTab.upload.rawValue, systemImage: AppTab.upload.systemImage)
                }
                .tag(AppTab.upload)

            NewsletterListView()
                .tabItem {
                    Label(AppTab.newsletters.rawValue, systemImage: AppTab.newsletters.systemImage)
                }
                .tag(AppTab.newsletters)

            SettingsView()
                .tabItem {
                    Label(AppTab.settings.rawValue, systemImage: AppTab.settings.systemImage)
                }
                .tag(AppTab.settings)
        }
        .alert("Error", isPresented: $mainViewModel.showError) {
            Button("OK", role: .cancel) {
                mainViewModel.clearError()
            }
        } message: {
            Text(mainViewModel.errorMessage ?? "An unknown error occurred")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(MainViewModel())
}
