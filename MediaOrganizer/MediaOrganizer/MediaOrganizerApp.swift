//
//  MediaOrganizerApp.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 13.09.2024.
//

import SwiftUI

@main
struct MediaOrganizerApp: App {
    let appState = AppState.shared
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            JobsView()
                .environmentObject(appState)
                .navigationTitle(Constants.appName)
                .frame(minWidth: 600, minHeight: 300)
        }
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: CommandGroupPlacement.appInfo) {
                Button("About \(Bundle.main.bundleURL.lastPathComponent.replacing(".\(Bundle.main.bundleURL.pathExtension)", with: String()))") { appDelegate.showInfoWindow() }
            }
        } 
        
        WindowGroup(id:Constants.windowIdJobSettings, content: {
            JobSettingsView()
                .environmentObject(appState)
                .navigationTitle(Constants.elJobSettings)
                .frame(minWidth: 500, minHeight: 500)
        }).windowResizability(.contentSize)
    }
}
