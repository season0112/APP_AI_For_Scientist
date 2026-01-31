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
        ZStack {
            // Dark background
            ThemeConfig.Background.primary
                .ignoresSafeArea()

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
            .accentColor(ThemeConfig.Neon.cyan)
            .onAppear {
                // Style tab bar with dark theme
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = UIColor(ThemeConfig.Background.secondary)

                // Unselected item colors
                appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.5)
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                    .foregroundColor: UIColor.white.withAlphaComponent(0.5)
                ]

                // Selected item colors (neon cyan)
                appearance.stackedLayoutAppearance.selected.iconColor = UIColor(ThemeConfig.Neon.cyan)
                appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                    .foregroundColor: UIColor(ThemeConfig.Neon.cyan)
                ]

                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
        .alert("Error", isPresented: $mainViewModel.showError) {
            Button("OK", role: .cancel) {
                mainViewModel.clearError()
            }
        } message: {
            Text(mainViewModel.errorMessage ?? "An unknown error occurred")
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .environmentObject(MainViewModel())
}
