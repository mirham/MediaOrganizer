//
//  JobsHeaderToolbarView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 10.10.2024.
//

import SwiftUI
import Factory

struct JobsHeaderToolbarView : View {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.controlActiveState) private var controlActiveState
    
    @Injected(\.jobService) private var jobService
    
    @State private var showOverRunJobs = false
    @State private var showOverAbortJobs = false
    
    var body: some View {
        Section {
            Button(Constants.toolbarRunJobs, systemImage: Constants.iconRun) {
                jobService.runCheckedJobs()
            }
            .withToolbarButtonStyle(showOver: showOverRunJobs, activeState: controlActiveState, color: .green)
            .disabled(!jobService.hasCheckedInactiveJobs())
            .popover(
                isPresented: $showOverRunJobs,
                content: { renderHint(hint: Constants.toolbarRunJobs) })
            .onHover(perform: { hovering in
                showOverRunJobs = hovering
                && jobService.hasCheckedInactiveJobs()
                && controlActiveState == .key
            })
            Button(Constants.toolbarAbortActiveJobs, systemImage: Constants.iconStop) {
                jobService.abortActiveJobs()
            }
            .withToolbarButtonStyle(showOver: showOverAbortJobs, activeState: controlActiveState, color: .red)
            .disabled(!jobService.hasActiveJobs())
            .popover(isPresented: $showOverAbortJobs, content: {
                renderHint(hint: Constants.toolbarAbortActiveJobs)
            })
            .onHover(perform: { hovering in
                showOverAbortJobs = hovering
                && jobService.hasActiveJobs()
                && controlActiveState == .key
            })
        }
    }
    
    // MARK: Private functions
    
    private func renderHint(hint: String) -> some View {
        let result = Text(hint)
            .padding()
            .interactiveDismissDisabled()
        
        return result
    }
}

private extension Button {
    func withToolbarButtonStyle(showOver: Bool, activeState: ControlActiveState, color: Color) -> some View {
        self.buttonStyle(.plain)
            .foregroundColor(showOver && activeState == .key ? color : .blue)
            .focusEffectDisabled()
            .font(.system(size: 30))
            .opacity(getViewOpacity(state: activeState))
    }
}

#Preview {
    JobsToolbarView().environmentObject(AppState())
}
