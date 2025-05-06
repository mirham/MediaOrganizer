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
    
    var body: some View {
        Section {
            Button(Constants.toolbarRunJobs, systemImage: Constants.iconRun) {
                Task {
                    await jobService.runCheckedJobsAsync()
                }
            }
            .withToolbarButtonStyle(showOver: showOverRunJobs, activeState: controlActiveState, color: .blue)
            .popover(isPresented: $showOverRunJobs, content: {
                renderHint(hint: Constants.toolbarRunJobs)
            })
            .onHover(perform: { hovering in
                showOverRunJobs = hovering && controlActiveState == .key
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
            .foregroundColor(showOver && activeState == .key ? color : .gray)
            .focusEffectDisabled()
            .font(.system(size: 17))
            .opacity(getViewOpacity(state: activeState))
    }
}

#Preview {
    JobsToolbarView().environmentObject(AppState())
}
