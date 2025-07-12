//
//  DraggableConditionElementsView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 07.05.2025.
//

import SwiftUI
import WrappingHStack

struct DraggableConditionElementsView: View {
    @EnvironmentObject var appState: AppState
    
    @Binding var selectedConditionTypeId: Int
    @Binding var draggedItem: DraggableElement<ConditionElement>?
    @Binding var conditionElements: [DraggableElement<ConditionElement>]
    
    var body: some View {
        HStack {
            WrappingHStack(alignment: .leading) {
                ForEach(conditionElements, id: \.id) {conditionElement in
                    ConditionElementEditView(element: conditionElement.element)
                        .onDrag({
                            if appState.current.isRuleElementSetupComplete {
                                self.draggedItem = conditionElement
                            }
                            
                            return NSItemProvider(object: conditionElement.element.displayText as NSString)
                        })
                        .onDrop(of: [.text], delegate: DropViewDelegate(
                            draggedItem: $draggedItem,
                            items: $conditionElements,
                            item: conditionElement))
                }
            }
            .padding(5)
        }
        .asConditionEditPanel()
        .padding(.leading, 5)
        .padding(.bottom, 10)
    }
}

private extension HStack {
    func asConditionEditPanel() -> some View {
        self.frame(minWidth: 400, maxWidth: .infinity, minHeight: 30)
            .contentShape(Rectangle())
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 6
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.blue, lineWidth: 1)
            )
    }
}
