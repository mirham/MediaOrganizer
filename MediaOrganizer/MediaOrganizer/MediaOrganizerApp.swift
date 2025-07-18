//
//  MediaOrganizerApp.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 13.09.2024.
//

import SwiftUI
import AppKit

@main
struct MediaOrganizerApp: App {
    let appState = AppState.shared
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup(id: Constants.windowIdMain) {
            JobsView()
                .environmentObject(appState)
                .navigationTitle(Constants.appName)
                .frame(minWidth: 600, minHeight: 300)
        }
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: CommandGroupPlacement.appInfo) {
                Button("\(Constants.elAbout) \(Bundle.main.bundleURL.lastPathComponent.replacing(".\(Bundle.main.bundleURL.pathExtension)", with: String()))") { appDelegate.showInfoWindow() }
            }
        }
        .windowResizability(.contentSize)
        
        WindowGroup(id: Constants.windowIdJobSettings, makeContent: {
            JobSettingsView()
                .environmentObject(appState)
                .navigationTitle(String(format: Constants.elJobSettings, getCurrentJobName()))
                .frame(minWidth: 560, minHeight: 500)
        })
        
        WindowGroup(id: Constants.windowIdLog, makeContent: {
            if let jobId = appState.current.logJobId {
                JobLogView(jobId: jobId)
                    .environmentObject(appState)
                    .navigationTitle(String(format: Constants.elJobLog, getCurrentJobName()))
                    .frame(minWidth: 400, minHeight: 400)
            }
        }).windowResizability(.contentSize)
    }
    
    // MARK: Private functions
    
    private func getCurrentJobName() -> String {
        return appState.current.job?.name ?? String()
    }
}
