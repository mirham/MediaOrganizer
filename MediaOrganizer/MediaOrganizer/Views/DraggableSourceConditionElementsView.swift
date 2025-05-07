//
//  DraggableSourceActionElementsView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 07.05.2024.
//

import SwiftUI
import WrappingHStack

struct DraggableSourceConditionElementsView: ElementContainerView {
    @EnvironmentObject var appState: AppState
    
    @Binding var selectedActionTypeId: Int
    @Binding var draggedItem: DraggableElement<ConditionElement>?
    @Binding var destinationElements: [DraggableElement<ConditionElement>]
    
    @State private var sourceElements = [DraggableElement<ConditionElement>]()
    
    var body: some View {
        WrappingHStack(alignment: .leading) {
            ForEach(sourceElements, id: \.id) {sourceElement in
                elementAsIconAndText(elementInfo: sourceElement.element)
                    .onDrag {
                        self.draggedItem = sourceElement
                        return NSItemProvider(object: sourceElement.element.displayText as NSString)
                    }
                    .onDrop(of: [.text], delegate: DropViewDelegate(
                        draggedItem: $draggedItem,
                        items: $destinationElements,
                        item: sourceElement
                    ))
            }
        }
        .padding(.leading, 10)
        .onAppear(perform: fillSourceElements)
        .onChange(of: selectedActionTypeId, fillSourceElements)
    }
    
    private func fillSourceElements() {
        sourceElements.removeAll()
        
        let currentActionType = appState.current.action?.type ?? .rename
        
        guard currentActionType.canBeCustomized else { return }
        
        for metadataCase in MetadataType.allCases {
            let elementInfo = ConditionElement(
                elementTypeId: metadataCase.id,
                displayText: metadataCase.shortDescription)
            let conditionElement = DraggableElement(element: elementInfo)
            sourceElements.append(conditionElement)
        }
    }
    
    // MARK: Private functions
    
    @ViewBuilder
    private func elementAsIconAndText(elementInfo: ConditionElement) -> some View {
        let label = elementInfo.displayText
        let options = getElementOptionsByTypeId(typeId: elementInfo.elementTypeId)
        
        HStack {
            if options.icon != nil {
                options.icon!
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            Text(label)
        }
        .padding(3)
        .background(
            RoundedRectangle(cornerRadius: 5, style: .continuous).fill(options.background)
        )
    }
}

