//
//  DraggableConditionElementsView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 01.10.2024.
//

import SwiftUI
import WrappingHStack

struct DraggableConditionElementsView: View {
    @EnvironmentObject var appState: AppState
    
    @Binding var selectedActionTypeId: Int
    @Binding var draggedItem: DraggableElement?
    @Binding var conditionElements: [DraggableElement]
    
    var body: some View {
        HStack {
            WrappingHStack(alignment: .leading) {
                ForEach(conditionElements, id: \.id) {conditionElement in
                    ActionElementEditView(elementInfo: conditionElement.elementInfo)
                        .onDrag({
                            self.draggedItem = conditionElement
                            return NSItemProvider(object: conditionElement.elementInfo.displayText as NSString)
                        })
                        .onDrop(of: [.text], delegate: DropViewDelegate(
                            draggedItem: $draggedItem,
                            items: $conditionElements,
                            item: conditionElement))
                }
            }
            .padding(5)
        }
        .asActionEditPanel()
        .isHidden(hidden: selectedActionTypeId == ActionType.delete.id, remove: true)
        .padding(.leading, 5)
        .padding(.bottom, 10)
    }
}

private extension HStack {
    func asActionEditPanel() -> some View {
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
