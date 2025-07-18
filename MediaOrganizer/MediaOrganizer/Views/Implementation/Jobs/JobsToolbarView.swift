//
//  JobsToolbarView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 16.09.2024.
//

import SwiftUI
import Factory

struct JobsToolbarView : View {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.controlActiveState) private var controlActiveState
    
    @Injected(\.jobService) private var jobService
    
    @State private var isJobRemoving = false
    
    @State private var showOverAddJob = false
    @State private var showOverEditJob = false
    @State private var showOverDuplicateJob = false
    @State private var showOverRemoveJob = false
    
    var body: some View {
        HStack {
            Button(
                Constants.toolbarAdd,
                systemImage: Constants.iconAdd,
                action: handleAddJobButtonClick)
            .withToolbarButtonStyle(
                showOver: showOverAddJob,
                activeState: controlActiveState,
                color: .green)
            .onHover(perform: { hovering in
                showOverAddJob = hovering && controlActiveState == .key
            })
            Button(
                Constants.toolbarEdit,
                systemImage: Constants.iconEdit,
                action: showJobSettingsWindow)
            .withToolbarButtonStyle(
                showOver: showOverEditJob,
                activeState: controlActiveState,
                color: .blue)
            .disabled(shouldDisablePanelButton())
            .isHidden(hidden: !jobService.doesCurrentJobExist(), remove: true)
            .onHover(perform: { hovering in
                showOverEditJob = hovering && controlActiveState == .key
            })
            Button(
                Constants.toolbarDuplicate,
                systemImage: Constants.iconDuplicate,
                action: handleDuplicateJobButtonClick)
            .withToolbarButtonStyle(
                showOver: showOverDuplicateJob,
                activeState: controlActiveState,
                color: .blue)
            .disabled(shouldDisablePanelButton())
            .isHidden(hidden: !jobService.doesCurrentJobExist(), remove: true)
            .onHover(perform: { hovering in
                showOverDuplicateJob = hovering && controlActiveState == .key
            })
            Button(Constants.toolbarRemove, systemImage: Constants.iconRemove) {
                isJobRemoving = true
            }
            .withToolbarButtonStyle(
                showOver: showOverRemoveJob,
                activeState: controlActiveState,
                color: .red)
            .disabled(shouldDisablePanelButton())
            .isHidden(hidden: !jobService.doesCurrentJobExist(), remove: true)
            .onHover(perform: { hovering in
                showOverRemoveJob = hovering && controlActiveState == .key
            })
            .alert(isPresented: $isJobRemoving) {
                Alert(title: Text(String(format: Constants.dialogHeaderRemoveJob, appState.current.job?.name ?? String())),
                      message: Text(Constants.dialogBodyRemoveJob),
                      primaryButton: Alert.Button.destructive(Text(Constants.dialogButtonDelete), action: handleRemoveJobClick),
                      secondaryButton: .default(Text(Constants.dialogButtonCancel)))
            }
        }
    }
    
    // MARK: Private functions
    
    private func shouldDisablePanelButton() -> Bool {
        return !jobService.doesCurrentJobExist()
        || (appState.current.job != nil && appState.current.job!.progress.isActive)
    }
    
    private func handleAddJobButtonClick() {
        jobService.resetCurrentJob()
        showJobSettingsWindow()
    }
    
    private func handleDuplicateJobButtonClick() {
        jobService.duplicateJob()
    }
    
    private func handleRemoveJobClick() {
        jobService.removeCurrentJob()
        isJobRemoving = false
    }
    
    private func showJobSettingsWindow() {
        if !appState.views.isWindowShown(windowId: Constants.windowIdJobSettings){
            openWindow(id: Constants.windowIdJobSettings)
        }
        
        ViewHelper.activateView(viewId: Constants.windowIdJobSettings)
    }
}

private extension Button {
    func withToolbarButtonStyle(
        showOver: Bool,
        activeState: ControlActiveState,
        color: Color) -> some View {
        self.buttonStyle(.plain)
            .foregroundColor(showOver && activeState == .key ? color : .gray)
            .focusEffectDisabled()
            .font(.system(size: 16))
            .opacity(getViewOpacity(state: activeState))
    }
}

#Preview {
    JobsToolbarView().environmentObject(AppState())
}
