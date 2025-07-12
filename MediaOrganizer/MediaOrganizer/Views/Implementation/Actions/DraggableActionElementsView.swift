//
//  DraggableActionElementsView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 01.10.2024.
//

import SwiftUI
import WrappingHStack

struct DraggableActionElementsView: View {
    @EnvironmentObject var appState: AppState
    
    @Binding var selectedActionTypeId: Int
    @Binding var draggedItem: DraggableElement<ActionElement>?
    @Binding var actionElements: [DraggableElement<ActionElement>]
    
    var body: some View {
        HStack {
            WrappingHStack(alignment: .leading) {
                ForEach(actionElements, id: \.id) {actionElement in
                    ActionElementEditView(element: actionElement.element)
                        .onDrag({
                            if appState.current.isRuleElementSetupComplete {
                                self.draggedItem = actionElement
                            }
                            
                            return NSItemProvider(object: actionElement.element.displayText as NSString)
                        })
                        .onDrop(of: [.text], delegate: DropViewDelegate(
                            draggedItem: $draggedItem,
                            items: $actionElements,
                            item: actionElement))
                }
            }
            .padding(5)
        }
        .asActionEditPanel()
        .isHidden(hidden: !ActionType(rawValue: selectedActionTypeId)!.canBeCustomized, remove: true)
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
