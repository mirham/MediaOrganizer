//
//  JobSettingsView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import SwiftUI
import Factory

struct JobSettingsView : View {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.controlActiveState) var controlActiveState
    
    @Injected(\.jobService) private var jobService
    
    @State private var currentEditMode: JobEditMode = .edit
    
    var body: some View {
        TabView {
            JobGeneralSettingsEditView()
                .tabItem {
                    Text(Constants.elGeneral)
                }
            RulesEditView()
                .tabItem {
                    Text(Constants.elRulesAndActions)
                }
        }
        .onAppear(perform: {
            openView()
        })
        .onDisappear(perform: {
            closeView()
        })
        .opacity(getViewOpacity(state: controlActiveState))
        .padding()
    }
    
    // MARK: Private functions
    
    private func openView() {
        appState.views.isJobSettingsViewShown = true
        
        ViewHelper.setUpView(
            viewName: Constants.windowIdJobSettings,
            onTop: false)
        
        if (appState.current.job == nil) {
            currentEditMode = .add
            appState.current.job = Job.makeDefault()
        }
    }
    
    private func closeView() {
        if (currentEditMode == .add) {
            jobService.addJob()
        }
        else {
            jobService.updateJob()
        }
        
        jobService.resetCurrentJob()
        
        appState.views.isJobSettingsViewShown = false
    }
}

#Preview {
    JobSettingsView().environmentObject(AppState())
}
