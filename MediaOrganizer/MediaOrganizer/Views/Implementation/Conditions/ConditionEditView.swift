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
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: Constants.iconInfo)
                        .asSmallInfoIcon()
                    Text(Constants.hintElements)
                        .font(.system(size: 12))
                }
                .opacity(0.7)
                .padding(.bottom, 3)
                Text(ConditionType(rawValue: selectedConditionTypeId)?.description ?? String())
                    .fontWeight(.bold)
                    .padding(.leading, 10)
                ValidationMessageView(
                    text: appState.current.validationMessage ?? String(),
                    offset: 5,
                    paddingBottom: 0,
                    hideFunc: hideValidationMessage)
                DraggableConditionElementsView(
                    selectedConditionTypeId: $selectedConditionTypeId,
                    draggedItem: $draggedItem,
                    conditionElements: $conditionElements)
                .onAppear {
                    selectedConditionTypeId = appState.current.condition?.type.id ?? ConditionType.cIf.id
                    
                    if appState.current.condition != nil {
                        conditionElements = appState.current.condition!.elements
                            .map({ return DraggableElement(element: $0) })
                    }
                    
                    appState.current.refreshSignal.toggle()
                }
                .onChange(of: conditionElements) {
                    if appState.current.condition != nil {
                        appState.current.condition!.elements = conditionElements
                            .map({ return $0.element })
                    }
                    appState.current.refreshSignal.toggle()
                }
                .onDisappear() {
                    appState.current.refreshSignal.toggle()
                }
                DraggableSourceElementsView<ConditionElement>(
                    selectedTypeId: $selectedConditionTypeId,
                    draggedItem: $draggedItem,
                    destinationElements: $conditionElements)
                ConditionPreviewView(conditionElements: conditionElements
                    .map({ return $0.element }))
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
    
    private func hideValidationMessage() -> Bool {
        return appState.current.validationMessage == nil
    }
}
