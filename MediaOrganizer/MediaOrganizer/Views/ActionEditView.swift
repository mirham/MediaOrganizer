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
    
    @Injected(\.actionService) private var actionService
    
    var body: some View {
        HStack {
            VStack {
                Picker(String(), selection: Binding(
                    get: { selectedActionTypeId },
                    set: {
                        selectedActionTypeId = $0
                        appState.current.action!.type = ActionType(rawValue: $0) ?? .rename
                        appState.objectWillChange.send()
                    }
                )) {
                    ForEach(ActionType.allCases, id: \.id) { item in
                        Text(item.description)
                    }
                }
                .pickerStyle(.menu)
                DraggableActionElementsView(
                    selectedActionTypeId: $selectedActionTypeId,
                    draggedItem: $draggedItem,
                    actionElements: $actionElements)
                .onAppear {
                    selectedActionTypeId = appState.current.action?.type.id ?? ActionType.rename.id
                    
                    if (appState.current.action != nil) {
                        actionElements = appState.current.action!.elements.map({ return DraggableElement(element: $0) })
                    }
                }
                .onDisappear {
                    if (appState.current.action != nil) {
                        appState.current.action!.elements = actionElements.map({ return $0.element })
                        
                        if let actionIndex = appState.current.rule!.actions.firstIndex(where: {$0.id == appState.current.action!.id}) {
                            appState.current.rule!.actions[actionIndex].elements
                            = appState.current.action!.elements
                        }
                    }
                    appState.objectWillChange.send()
                }
                DraggableSourceActionElementsView(
                    selectedActionTypeId: $selectedActionTypeId,
                    draggedItem: $draggedItem,
                    destinationElements: $actionElements)
                ActionPreviewView(actionElements: actionElements.map({ return $0.element }))
                    .padding(10)
            }
        }
        .padding(.top, 5)
        .padding(.bottom, 5)
        .padding(.trailing, 5)
        .contentShape(Rectangle())
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
