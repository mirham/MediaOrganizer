//
//  DraggableSourceElementsView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 30.09.2024.
//

import SwiftUI
import WrappingHStack

struct DraggableSourceElementsView<T: ElementType>: ElementContainerView {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var selectedTypeId: Int
    @Binding var draggedItem: DraggableElement<T>?
    @Binding var destinationElements: [DraggableElement<T>]
    
    @State private var sourceElements = [DraggableElement<T>]()
    
    var body: some View {
        WrappingHStack(alignment: .leading) {
            ForEach(sourceElements, id: \.id) {sourceElement in
                elementAsIconAndText(elementInfo: sourceElement.element)
                    .onDrag {
                        if appState.current.isRuleElementSetupComplete {
                            self.draggedItem = sourceElement
                        }
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
        .onChange(of: selectedTypeId, fillSourceElements)
    }
    
    private func fillSourceElements() {
        sourceElements.removeAll()
        
        let isCustomizable = getCustomizationAbilityByTypeId(typeId: selectedTypeId)
        
        guard isCustomizable else { return }
        
        for metadataCase in MetadataType.allCases {
            let elementInfo = T.init(
                elementTypeId: metadataCase.id,
                displayText: metadataCase.shortDescription)
            let actionElement = DraggableElement(element: elementInfo)
            sourceElements.append(actionElement)
        }
        
        let optionalElements: [DraggableElement<T>] = getOptionalElements(typeId: selectedTypeId)
        
        for optionalElement in optionalElements {
            sourceElements.append(optionalElement)
        }
    }
    
    // MARK: Private functions
    
    @ViewBuilder
    private func elementAsIconAndText(elementInfo: T) -> some View {
        let label = elementInfo.displayText
        let options = getElementOptionsByTypeId(
            typeId: elementInfo.elementTypeId,
            colorScheme: colorScheme)
        
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

