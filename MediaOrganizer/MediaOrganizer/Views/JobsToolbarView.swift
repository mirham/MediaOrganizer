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
    @State private var showOverRemoveJob = false
    
    var body: some View {
        HStack {
            Button(Constants.toolbarAddJob, systemImage: Constants.iconAdd) {
                jobService.resetCurrentJob()
                showJobSettingsWindow()
            }
            .withToolbarButtonStyle(showOver: showOverAddJob, activeState: controlActiveState, color: .green)
            .onHover(perform: { hovering in
                showOverAddJob = hovering && controlActiveState == .key
            })
            Button(Constants.toolbarRemoveJob, systemImage: Constants.iconRemove) {
                isJobRemoving = true
            }
            .withToolbarButtonStyle(showOver: showOverRemoveJob, activeState: controlActiveState, color: .red)
            .disabled(!jobService.doesCurrentJobExist())
            .onHover(perform: { hovering in
                showOverRemoveJob = hovering && controlActiveState == .key
            })
            .alert(isPresented: $isJobRemoving) {
                Alert(title: Text(String(format: Constants.dialogHeaderRemoveJob, appState.current.job?.name ?? String())),
                      message: Text(Constants.dialogBodyRemoveJob),
                      primaryButton: Alert.Button.destructive(Text(Constants.dialogButtonDelete), action: removeJobClickHandler),
                      secondaryButton: .default(Text(Constants.dialogButtonCancel)))
            }
        }
    }
    
    // MARK: Private functions
    
    private func removeJobClickHandler() {
        jobService.removeCurrentJob()
        isJobRemoving = false
    }
    
    private func showJobSettingsWindow() {
        if (!appState.views.isJobSettingsViewShown){
            openWindow(id: Constants.windowIdJobSettings)
            ViewHelper.activateView(viewId: Constants.windowIdJobSettings)
        }
        else {
            ViewHelper.activateView(viewId: Constants.windowIdJobSettings)
        }
    }
}

private extension Button {
    func withToolbarButtonStyle(showOver: Bool, activeState: ControlActiveState, color: Color) -> some View {
        self.buttonStyle(.plain)
            .foregroundColor(showOver && activeState == .key ? color : .gray)
            .focusEffectDisabled()
            .font(.system(size: 17))
            .opacity(getViewOpacity(state: activeState))
    }
}

#Preview {
    JobsToolbarView().environmentObject(AppState())
}
