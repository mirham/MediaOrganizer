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
    @State private var showOverDuplicateRule = false
    @State private var showOverMoveUp = false
    @State private var showOverMoveDown = false
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
            Button(
                Constants.toolbarUp,
                systemImage: Constants.iconUp,
                action: handleMoveUpButtonClick)
            .withToolbarButtonStyle(
                showOver: showOverMoveUp,
                activeState: controlActiveState,
                color: .blue)
            .disabled(shouldDisablePanelButton())
            .isHidden(hidden: !ruleService.doesCurrentRuleExist(), remove: true)
            .onHover(perform: { hovering in
                showOverMoveUp = hovering && controlActiveState == .key
            })
            Button(
                Constants.toolbarDown,
                systemImage: Constants.iconDown,
                action: handleMoveDownButtonClick)
            .withToolbarButtonStyle(
                showOver: showOverMoveDown,
                activeState: controlActiveState,
                color: .blue)
            .disabled(shouldDisablePanelButton())
            .isHidden(hidden: !ruleService.doesCurrentRuleExist(), remove: true)
            .onHover(perform: { hovering in
                showOverMoveDown = hovering && controlActiveState == .key
            })
            Button(
                Constants.toolbarDuplicate,
                systemImage: Constants.iconDuplicate,
                action: handleDuplicateRuleButtonClick)
            .withToolbarButtonStyle(
                showOver: showOverDuplicateRule,
                activeState: controlActiveState,
                color: .blue)
            .disabled(shouldDisablePanelButton())
            .isHidden(hidden: !ruleService.doesCurrentRuleExist(), remove: true)
            .onHover(perform: { hovering in
                showOverDuplicateRule = hovering && controlActiveState == .key
            })
            Button(
                Constants.toolbarRemove,
                systemImage: Constants.iconRemove,
                action: handleRemoveRuleButtonClick)
            .withToolbarButtonStyle(
                showOver: showOverRemoveRule,
                activeState: controlActiveState,
                color: .red)
            .disabled(shouldDisablePanelButton())
            .isHidden(hidden: !ruleService.doesCurrentRuleExist(), remove: true)
            .onHover(perform: { hovering in
                showOverRemoveRule = hovering && controlActiveState == .key
            })
            .alert(isPresented: $isRuleRemoving) {
                Alert(
                    title: Text(Constants.dialogHeaderRemoveRule),
                    message: Text(Constants.dialogBodyRemoveRule),
                    primaryButton: Alert.Button.destructive(Text(Constants.dialogButtonDelete), action: handleRemoveRule),
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
    
    private func handleDuplicateRuleButtonClick() {
        ruleService.duplicateRule()
        appState.current.refreshSignal.toggle()
    }
    
    private func handleMoveUpButtonClick() {
        ruleService.moveRuleUp()
        appState.current.refreshSignal.toggle()
    }
    
    private func handleMoveDownButtonClick() {
        ruleService.moveRuleDown()
        appState.current.refreshSignal.toggle()
    }
    
    private func handleRemoveRuleButtonClick() {
        guard let currentRule = appState.current.rule
        else { return }
        
        if currentRule.isEmpty {
            ruleService.removeCurrentRule()
            appState.current.refreshSignal.toggle()
        }
        else {
            isRuleRemoving = true
        }
        
        if let currentJob = appState.current.job {
            if currentJob.rules.isEmpty {
                ViewHelper.setUpCloseViewButton(
                    viewName: Constants.windowIdJobSettings,
                    enable: true)
            }
        }
    }
    
    private func handleRemoveRule() {
        ruleService.removeCurrentRule()
        isRuleRemoving = false
        
        if let currentJob = appState.current.job {
            let hasEmptyRule = currentJob.rules.contains(where: { $0.isEmpty })
            ViewHelper.setUpCloseViewButton(
                viewName: Constants.windowIdJobSettings,
                enable: !hasEmptyRule)
        }
        
        appState.current.refreshSignal.toggle()
    }
    
    private func renderHint(hint: String) -> some View {
        let result = Text(hint)
            .padding()
            .interactiveDismissDisabled()
        
        return result
    }
    
    private func shouldDisablePanelButton() -> Bool {
        return !ruleService.doesCurrentRuleExist() || !appState.current.isRuleSetupComplete
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
