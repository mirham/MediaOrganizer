//
//  ConditionPreviewView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 05.10.2024.
//

import SwiftUI
import WrappingHStack

struct ConditionPreviewView: ElementContainerView {
    @EnvironmentObject var appState: AppState
    
    var conditionElements: [ConditionElement]
    
    private let dateFormatter = DateFormatter()
    private let dateExample = Date.now
    private let extensionExample = Date.now
    
    var body: some View {
        WrappingHStack(alignment: .leading, horizontalSpacing: 5) {
            Text(Constants.elConditionPreview)
                .font(.subheadline)
            ForEach(conditionElements, id: \.id) { element in
                let elementOptions = getElementOptionsByTypeId(typeId: element.elementTypeId)
                let operatorDescription = getOperatorDescription(
                    conditionValueType: elementOptions.conditionValueType,
                    selectedOperatorTypeId: element.selectedOperatorTypeId)
                
                HStack() {
                    Text(element.displayText
                         + getConditionFormatDescription(
                            conditionValueType: elementOptions.conditionValueType,
                            selectedDateFormatTypeId: element.selectedDateFormatType?.id))
                    Text(operatorDescription)
                        .foregroundStyle(.gray)
                        .font(.system(size: 10))
                        .isHidden(hidden: operatorDescription == String(), remove: true)
                    Text(element.value.toString())
                        .isHidden(hidden: element.value.toString() == String(), remove: true)
                }
                .font(.subheadline)
                .background(
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .fill(elementOptions.background)
                )
            }
        }
        .opacity(0.8)
        .frame(maxWidth: .infinity)
        .isHidden(hidden: conditionElements.isEmpty, remove: false)
    }
    
    // MARK: Private functions
    
    private func getFormattedDate(elementInfo: ConditionElement) -> String {
        dateFormatter.dateFormat = (elementInfo.selectedDateFormatType ?? DateFormatType.dateEu).formula
        let date = dateExample
        let result = dateFormatter.string(from: date)
        
        return result
    }
}
