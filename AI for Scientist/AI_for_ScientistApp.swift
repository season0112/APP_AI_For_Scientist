//
//  AI_for_ScientistApp.swift
//  AI for Scientist
//
//  Main app entry point with state object initialization
//

import SwiftUI

@main
struct AI_for_ScientistApp: App {
    @StateObject private var mainViewModel = MainViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(mainViewModel)
        }
    }
}
