//
//  ActionView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import SwiftUI

struct ActionView: View {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.controlActiveState) private var controlActiveState
    
    @State private var showEditor: Bool = false
    
    private let ruleService = RuleService.shared
    private let actionService = ActionService.shared
    
    private var ruleId: UUID
    private var action: Action
    
    init(ruleId: UUID, action: Action) {
        self.action = action
        self.ruleId = ruleId
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(action.description())
                    .frame(maxWidth: 90, alignment: .leading)
                    .contentShape(Rectangle())
                    .padding(5)
                    .isHidden(hidden: showEditor, remove: true)
                ActionEditView()
                    .padding(5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .isHidden(hidden: !showEditor || !actionService.isCurrentAction(actionId: action.id), remove: true )
                ActionPreviewView(actionElements: action.elements)
                    .isHidden(hidden: !action.type.canBeCustomized, remove: true)
                    .frame(maxWidth: .infinity,  alignment: .leading)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .onChange(of: action.elements, {  })
                Button(String(), systemImage: Constants.iconEdit, action: actionEditClickHandler)
                    .withSmallEditButtonStyle(activeState: controlActiveState)
                    .isHidden(hidden: !ruleService.isCurrentRule(ruleId: ruleId) || appState.current.isActionInEditMode, remove: true )
                Button(String(), systemImage: Constants.iconCheck, action: actionSaveClickHanlder)
                    .withSmallSaveButtonStyle(activeState: controlActiveState)
                    .isHidden(hidden: !showEditor, remove: true )
                Button(String(), systemImage: Constants.iconRemove, action: actionRemoveClickHandler)
                    .withSmallRemoveButtonStyle(activeState: controlActiveState)
                    .isHidden(hidden: !ruleService.isCurrentRule(ruleId: ruleId), remove: true )
            }
            .background(actionService.isCurrentAction(actionId: action.id) && appState.current.isActionInEditMode
                        ? Color(hex: Constants.colorHexSelection)
                        : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    // MARK: Private functions
    
    private func actionEditClickHandler () {
        appState.current.action = action
        appState.current.isActionInEditMode = true
        showEditor = true
    }
    
    private func actionSaveClickHanlder() {
        appState.current.isActionInEditMode = false
        showEditor = false
    }
    
    private func actionRemoveClickHandler () {
        actionService.removeActionById(actionId: action.id)
        appState.current.isActionInEditMode = false
        showEditor = false
    }
}

