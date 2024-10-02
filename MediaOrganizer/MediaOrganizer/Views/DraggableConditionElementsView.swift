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
    
    @Binding var selectedActionTypeRaw: Int
    @Binding var draggedItem: DraggableElement?
    @Binding var conditionElements: [DraggableElement]
    
    var body: some View {
        HStack {
            WrappingHStack(conditionElements, id: \.self, lineSpacing: 10) { conditionElement in
                Text(conditionElement.elementInfo.displayText)
                    .fixedSize(horizontal: false, vertical: false)
                    .padding(3)
                    .background(
                        RoundedRectangle(cornerRadius: 5, style: .continuous).fill(Color.gray)
                    )
                    .onDrag({
                        self.draggedItem = conditionElement
                        return NSItemProvider(object: conditionElement.elementInfo.displayText as NSString)
                    })
                    .onDrop(of: [.text], delegate: DropViewDelegate(
                        draggedItem: $draggedItem,
                        items: $conditionElements,
                        item: conditionElement))
            }
            .padding(5)
        }
        .asActionEditPanel()
        .padding(.leading, 5)
        .padding(.bottom, 10)
    }
}

private extension HStack {
    func asActionEditPanel() -> some View {
        self.frame(minWidth: 350, minHeight: 30)
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
