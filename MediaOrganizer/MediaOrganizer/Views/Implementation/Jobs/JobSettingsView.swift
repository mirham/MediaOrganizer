//
//  JobSettingsView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import SwiftUI
import Factory
import Combine

struct JobSettingsView : View {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.controlActiveState) var controlActiveState
    @Environment(\.dismiss) private var dismiss
    
    @Injected(\.jobService) private var jobService
    
    @State private var currentEditMode: JobEditMode = .edit
    @State private var showAlert = false
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: Binding(
            get: { selectedTab },
            set: { newTab in
                let canTabBeSwitched = appState.current.isRuleSetupComplete
                    && appState.current.allRulesValid
                
                if canTabBeSwitched {
                    selectedTab = newTab
                }
                else {
                    appState.current.refreshSignal.toggle()
                }
            }
        )) {
            JobGeneralSettingsEditView()
                .tabItem {
                    Text(Constants.elGeneral)
                }
                .tag(0)
            RulesEditView()
                .tabItem {
                    Text(Constants.elRules)
                }
                .tag(1)
        }
        .tabViewStyle(.grouped)
        .padding(10)
        .onAppear(perform: openView)
        .onDisappear(perform: closeView)
        .opacity(getViewOpacity(state: controlActiveState))
    }
    
    // MARK: Private functions
    
    private func openView() {
        appState.views.addShownWindow(windowId: Constants.windowIdJobSettings)
        
        ViewHelper.setUpView(
            viewName: Constants.windowIdJobSettings,
            onTop: true)
        
        guard appState.current.job != nil else {
            currentEditMode = .add
            appState.current.job = Job.initDefault()
            
            return
        }
    }
    
    private func closeView() {
        if currentEditMode == .add {
            jobService.addJob()
        }
        else {
            jobService.updateJob()
        }
        
        jobService.resetCurrentJob()
        
        appState.views.removeShownWindow(windowId: Constants.windowIdJobSettings)
    }
}

#Preview {
    JobSettingsView().environmentObject(AppState())
}
