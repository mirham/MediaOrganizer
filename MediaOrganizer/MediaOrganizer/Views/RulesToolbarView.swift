//
//  RulesToolbarView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 18.09.2024.
//

import SwiftUI

struct RulesToolbarView : View {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.controlActiveState) private var controlActiveState
    
    private let ruleService = RuleService.shared
    
    @State private var showOverAddRule = false
    @State private var showOverRemoveRule = false
    @State private var isRuleRemoving = false
    
    var body: some View {
        Section {
            Button(Constants.toolbarAddRule, systemImage: Constants.iconAdd) {
                ruleService.resetCurrentRule()
                ruleService.createRule()
                ruleService.addRule()
            }
            .withToolbarButtonStyle(showOver: showOverAddRule, activeState: controlActiveState, color: .green)
            .onHover(perform: { hovering in
                showOverAddRule = hovering && controlActiveState == .key
            })
            Button(Constants.toolbarRemoveRule, systemImage: Constants.iconRemove) {
                isRuleRemoving = true
            }
            .withToolbarButtonStyle(showOver: showOverRemoveRule, activeState: controlActiveState, color: .red)
            .disabled(!ruleService.doesCurrentRuleExist())
            .onHover(perform: { hovering in
                showOverRemoveRule = hovering && controlActiveState == .key
            })
            .alert(isPresented: $isRuleRemoving) {
                Alert(title: Text(Constants.dialogHeaderRemoveRule),
                      message: Text(Constants.dialogBodyRemoveRule),
                      primaryButton: Alert.Button.destructive(Text(Constants.dialogButtonDelete), action: removeRuleClickHandler),
                      secondaryButton: .default(Text(Constants.dialogButtonCancel)))
            }
        }
    }
    
    // MARK: Private functions
    
    private func removeRuleClickHandler() {
        ruleService.removeCurrentRule()
        isRuleRemoving = false
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
            .font(.system(size: 18))
            .opacity(getViewOpacity(state: activeState))
    }
}

#Preview {
    RulesToolbarView().environmentObject(AppState())
}
