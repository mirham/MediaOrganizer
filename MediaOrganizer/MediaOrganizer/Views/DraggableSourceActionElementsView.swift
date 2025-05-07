//
//  DraggableSourceActionElementsView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 30.09.2024.
//

import SwiftUI
import WrappingHStack

struct DraggableSourceActionElementsView: ElementContainerView {
    @EnvironmentObject var appState: AppState
    
    @Binding var selectedActionTypeId: Int
    @Binding var draggedItem: DraggableElement<ActionElement>?
    @Binding var destinationElements: [DraggableElement<ActionElement>]
    
    @State private var sourceElements = [DraggableElement<ActionElement>]()
    
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
            let elementInfo = ActionElement(
                elementTypeId: metadataCase.id,
                displayText: metadataCase.shortDescription)
            let actionElement = DraggableElement(element: elementInfo)
            sourceElements.append(actionElement)
        }
        
        var optionalElements = [ActionElement]()
        
        for elementCase in ElementType.allCases {
            let elementInfo = ActionElement(
                elementTypeId: elementCase.id,
                displayText: elementCase.description)
            optionalElements.append(elementInfo)
        }
        
        switch currentActionType {
            case .copyToFolder, .moveToFolder:
                for optionalElement in optionalElements {
                    let actionElement = DraggableElement(element: optionalElement)
                    sourceElements.append(actionElement)
                }
            case .rename:
                for optionalElement in optionalElements.filter({$0.elementTypeId != ElementType.slash.id}) {
                    let actionElement = DraggableElement(element: optionalElement)
                    sourceElements.append(actionElement)
                }
            case .delete, .skip:
                return
        }
    }
    
    // MARK: Private functions
    
    @ViewBuilder
    private func elementAsIconAndText(elementInfo: ActionElement) -> some View {
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

