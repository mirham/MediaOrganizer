//
//  ActionEditView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import SwiftUI
import Factory

struct ActionEditView: View {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.controlActiveState) private var controlActiveState
    
    @State private var selectedActionTypeId = ActionType.rename.id
    @State private var actionElements = [DraggableElement<ActionElement>]()
    @State private var draggedItem: DraggableElement<ActionElement>?
    
    @Injected(\.ruleService) private var ruleService
    @Injected(\.actionService) private var actionService
    
    var body: some View {
        HStack {
            VStack {
                Picker(String(), selection: Binding(
                    get: { selectedActionTypeId },
                    set: {
                        selectedActionTypeId = $0
                        appState.current.action!.type = ActionType(rawValue: $0) ?? .rename
                        ruleService.validateRule(rule: appState.current.rule)
                        appState.current.refreshSignal.toggle()
                    }
                )) {
                    ForEach(ActionType.allCases, id: \.id) { item in
                        Text(item.description)
                    }
                }
                .disabled(appState.current.validationMessage != nil)
                .pickerStyle(.menu)
                ValidationMessageView(
                    text: appState.current.validationMessage ?? String(),
                    offset: 5,
                    paddingBottom: 0,
                    hideFunc: hideValidationMessage)
                DraggableActionElementsView(
                    selectedActionTypeId: $selectedActionTypeId,
                    draggedItem: $draggedItem,
                    actionElements: $actionElements)
                .onAppear {
                    selectedActionTypeId = appState.current.action?.type.id ?? ActionType.rename.id
                    
                    if appState.current.action != nil {
                        actionElements = appState.current.action!.elements
                            .map({ return DraggableElement(element: $0) })
                    }
                    
                    appState.current.refreshSignal.toggle()
                }
                .onChange(of: actionElements) {
                    if appState.current.action != nil {
                        appState.current.action!.elements = actionElements
                            .map({ return $0.element })
                    }
                    appState.current.refreshSignal.toggle()
                }
                .onDisappear() {
                    appState.current.refreshSignal.toggle()
                }
                DraggableSourceElementsView(
                    selectedTypeId: $selectedActionTypeId,
                    draggedItem: $draggedItem,
                    destinationElements: $actionElements)
                ActionPreviewView(actionElements: actionElements
                    .map({ return $0.element }))
                    .isHidden(hidden:!isPreviewEnabled(), remove:true)
                    .padding(10)
            }
        }
        .padding(.top, 5)
        .padding(.bottom, 5)
        .padding(.trailing, 5)
        .contentShape(Rectangle())
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    // MARK: Private functions
    
    private func isPreviewEnabled() -> Bool {
        return selectedActionTypeId == ActionType.rename.id
            || selectedActionTypeId == ActionType.copyToFolder.id
            || selectedActionTypeId == ActionType.moveToFolder.id
    }
    
    private func hideValidationMessage() -> Bool {
        return appState.current.validationMessage == nil
    }
}
