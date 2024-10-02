//
//  DraggableSourceElementsView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 30.09.2024.
//

import SwiftUI
import WrappingHStack

struct DraggableSourceElementsView: View {
    @EnvironmentObject var appState: AppState
    
    @Binding var selectedActionTypeRaw: Int
    @Binding var draggedItem: DraggableElement?
    @Binding var destinationElements: [DraggableElement]
    
    @State private var sourceElements = [DraggableElement]()
    
    var body: some View {
        WrappingHStack(sourceElements, id: \.self, lineSpacing: 10) { sourceElement in
            elementAsIconAndText(elementInfo: sourceElement.elementInfo)
                .onDrag {
                    self.draggedItem = sourceElement
                    return NSItemProvider(object: sourceElement.elementInfo.displayText as NSString)
                }
                .onDrop(of: [.text], delegate: DropViewDelegate(
                    draggedItem: $draggedItem,
                    items: $destinationElements,
                    item: sourceElement
                ))
        }
        .padding(.leading, 10)
        .onAppear(perform: fillSourceElements)
        .onChange(of: selectedActionTypeRaw, fillSourceElements)
    }
    
    private func fillSourceElements() {
        destinationElements.removeAll()
        sourceElements.removeAll()
        
        let currentActionType = appState.current.action?.type ?? .rename
        
        guard currentActionType != .delete else { return }
        
        for metadataCase in MetadataType.allCases {
            let elementInfo = ElementInfo(
                elementTypeId: metadataCase.rawValue,
                displayText: metadataCase.shortDescription,
                settingType: ElementValueType.text)
            let actionElement = DraggableElement(elementInfo: elementInfo)
            sourceElements.append(actionElement)
        }
        
        var optionalElements = [ElementInfo]()
        
        for elementCase in ElementType.allCases {
            let elementInfo = ElementInfo(
                elementTypeId: elementCase.rawValue,
                displayText: elementCase.description,
                settingType: ElementValueType.text)
            optionalElements.append(elementInfo)
        }
        
        switch currentActionType {
            case .copyToFolder, .moveToFolder:
                for optionalElement in optionalElements {
                    let actionElement = DraggableElement(elementInfo: optionalElement)
                    sourceElements.append(actionElement)
                }
            case .rename:
                for optionalElement in optionalElements.filter({$0.elementTypeId != ElementType.slash.id}) {
                    let actionElement = DraggableElement(elementInfo: optionalElement)
                    sourceElements.append(actionElement)
                }
                
            case .delete:
                return
        }
    }
    
    // MARK: Private functions
    
    @ViewBuilder
    private func elementAsIconAndText(elementInfo: ElementInfo) -> some View {
        let label = elementInfo.displayText
        let options = ElementHelper.getElementOptionsByTypeId(typeId: elementInfo.elementTypeId)
        
        if(options != nil) {
            HStack {
                if options!.icon != nil {
                    options!.icon!
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                Text(label)
            }
            .padding(3)
            .background(
                RoundedRectangle(cornerRadius: 5, style: .continuous).fill(options!.backgound)
            )
        }
    }
}

