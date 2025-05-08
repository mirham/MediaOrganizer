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
        WrappingHStack(alignment: .leading, horizontalSpacing: 0) {
            Text("Condition: ")
                .font(.subheadline)
            ForEach(conditionElements, id: \.id) { element in
                let elementOptions = getElementOptionsByTypeId(typeId: element.elementTypeId)
                HStack(spacing: 0) {
                    Text(element.displayText
                         + getConditionFormatDescription(
                            conditionValueType: elementOptions.conditionValueType,
                            selectedFormatTypeId: element.selectedFormatTypeId))
                        .padding(.trailing, 3)
                    Text(getOperatorDescription(
                        conditionValueType: elementOptions.conditionValueType,
                        selectedOperatorTypeId: element.selectedOperatorTypeId))
                        .foregroundStyle(.gray)
                        .font(.system(size: 10))
                        .padding(.trailing, 3)
                    Text(element.value.toString())
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
        dateFormatter.dateFormat = DateFormatType(rawValue: elementInfo.selectedFormatTypeId ?? DateFormatType.dateEu.id)!.formula
        let date = dateExample
        let result = dateFormatter.string(from: date)
        
        return result
    }
}
