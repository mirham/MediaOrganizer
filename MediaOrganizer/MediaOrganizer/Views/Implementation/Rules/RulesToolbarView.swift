//
//  RulesToolbarView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 18.09.2024.
//

import SwiftUI
import Factory

struct RulesToolbarView : View {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.controlActiveState) private var controlActiveState
    
    @Injected(\.ruleService) private var ruleService
    
    @State private var showOverAddRule = false
    @State private var showOverRemoveRule = false
    @State private var isRuleRemoving = false
    
    var body: some View {
        HStack {
            Button(
                Constants.toolbarAdd,
                systemImage: Constants.iconAdd,
                action: handleAddRuleButtonClick)
            .withToolbarButtonStyle(
                showOver: showOverAddRule,
                activeState: controlActiveState,
                color: .green)
            .onHover(perform: { hovering in
                showOverAddRule = hovering && controlActiveState == .key
            })
            .disabled(!appState.current.isRuleSetupComplete)
            Button(Constants.toolbarRemove, systemImage: Constants.iconRemove) {
                isRuleRemoving = true
            }
            .withToolbarButtonStyle(
                showOver: showOverRemoveRule,
                activeState: controlActiveState,
                color: .red)
            .disabled(!ruleService.doesCurrentRuleExist() || !appState.current.isRuleSetupComplete)
            .isHidden(hidden: !ruleService.doesCurrentRuleExist(), remove: true)
            .onHover(perform: { hovering in
                showOverRemoveRule = hovering && controlActiveState == .key
            })
            .alert(isPresented: $isRuleRemoving) {
                Alert(
                    title: Text(Constants.dialogHeaderRemoveRule),
                    message: Text(Constants.dialogBodyRemoveRule),
                    primaryButton: Alert.Button.destructive(Text(Constants.dialogButtonDelete), action: handleRemoveRuleButtonClick),
                    secondaryButton: .default(Text(Constants.dialogButtonCancel)))
            }
        }
    }
    
    // MARK: Private functions
    
    private func handleAddRuleButtonClick() {
        ruleService.resetCurrentRule()
        ruleService.createRule()
        ruleService.addRule()
        ViewHelper.setUpCloseViewButton(
            viewName: Constants.windowIdJobSettings,
            enable: false)
    }
    
    private func handleRemoveRuleButtonClick() {
        ruleService.removeCurrentRule()
        isRuleRemoving = false
        
        if let currentJob = appState.current.job {
            let hasEmptyRule = currentJob.rules.contains(where: { $0.isEmpty })
            ViewHelper.setUpCloseViewButton(
                viewName: Constants.windowIdJobSettings,
                enable: !hasEmptyRule)
        }
    }
    
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
            .font(.system(size: 16))
            .opacity(getViewOpacity(state: activeState))
    }
}

#Preview {
    RulesToolbarView().environmentObject(AppState())
}
