//
//  ActionEditView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import SwiftUI

struct ActionEditView: View {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.controlActiveState) private var controlActiveState
    
    @State private var selectedActionTypeRaw = ActionType.rename.rawValue
    @State private var actionElements = [DraggableElement]()
    @State private var draggedItem: DraggableElement?
    
    private let actionService = ActionService.shared
    
    var body: some View {
        HStack {
            VStack {
                Picker(String(), selection: Binding(
                    get: { appState.current.action?.type.rawValue ?? ActionType.rename.rawValue },
                    set: {
                        selectedActionTypeRaw = $0
                        appState.current.action!.type = ActionType(rawValue: $0) ?? .rename
                        appState.objectWillChange.send()
                    }
                )) {
                    ForEach(ActionType.allCases, id: \.id) { item in
                        Text(item.description)
                    }
                }
                .pickerStyle(.menu)
                DraggableConditionElementsView(
                    selectedActionTypeRaw: $selectedActionTypeRaw,
                    draggedItem: $draggedItem,
                    conditionElements: $actionElements)
                DraggableSourceElementsView(
                    selectedActionTypeRaw: $selectedActionTypeRaw,
                    draggedItem: $draggedItem,
                    destinationElements: $actionElements)
            }
            Button(String(), systemImage: Constants.iconRemove, action: actionService.removeCurrentAction)
                .withRemoveButtonStyle(activeState: controlActiveState)
        }
        .padding(.top, 5)
        .padding(.bottom, 5)
        .padding(.trailing, 5)
        .contentShape(Rectangle())
        .background(Color(hex: Constants.colorHexSelection))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onAppear {
            appState.current.isActionInEditMode = true
        }
        .onDisappear {
            appState.current.isActionInEditMode = false
        }
    }
}

private extension Button {
    func withRuleButtonStyle(activeState: ControlActiveState) -> some View {
        self.buttonStyle(.plain)
            .focusEffectDisabled()
            .font(.system(size: 16))
            .opacity(getViewOpacity(state: activeState))
    }
    
    func withRemoveButtonStyle(activeState: ControlActiveState) -> some View {
        self.withRuleButtonStyle(activeState: activeState)
            .foregroundStyle(.red)
    }
}
