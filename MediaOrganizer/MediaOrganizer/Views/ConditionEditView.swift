//
//  ConditionEditView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 07.05.2025.
//

import SwiftUI
import Factory

struct ConditionEditView: View {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.controlActiveState) private var controlActiveState
    
    @State private var selectedConditionTypeId = ConditionType.cIf.id
    @State private var conditionElements = [DraggableElement<ConditionElement>]()
    @State private var draggedItem: DraggableElement<ConditionElement>?
    
    @Injected(\.actionService) private var actionService
    
    var body: some View {
        HStack {
            VStack {
                Picker(String(), selection: Binding(
                    get: { selectedConditionTypeId },
                    set: {
                        selectedConditionTypeId = $0
                        appState.current.condition!.type = ConditionType(rawValue: $0) ?? .cIf
                        appState.objectWillChange.send()
                    }
                )) {
                    ForEach(ConditionType.allCases, id: \.id) { item in
                        Text(item.description)
                    }
                }
                .pickerStyle(.menu)
                DraggableConditionElementsView(
                    selectedConditionTypeId: $selectedConditionTypeId,
                    draggedItem: $draggedItem,
                    conditionElements: $conditionElements)
                .onAppear {
                    selectedConditionTypeId = appState.current.condition?.type.id ?? ConditionType.cIf.id
                    
                    if (appState.current.condition != nil) {
                        conditionElements = appState.current.condition!.elements.map({ return DraggableElement(element: $0) })
                    }
                }
                .onDisappear {
                    if (appState.current.condition != nil) {
                        appState.current.condition!.elements = conditionElements.map({ return $0.element })
                        
                        if let conditionIndex = appState.current.rule!.conditions.firstIndex(where: {$0.id == appState.current.condition!.id}) {
                            appState.current.rule!.conditions[conditionIndex].elements
                            = appState.current.condition!.elements
                        }
                    }
                    appState.objectWillChange.send()
                }
                DraggableSourceElementsView<ConditionElement>(
                    selectedTypeId: $selectedConditionTypeId,
                    draggedItem: $draggedItem,
                    destinationElements: $conditionElements)
                ConditionPreviewView(conditionElements: conditionElements.map({ return $0.element }))
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
