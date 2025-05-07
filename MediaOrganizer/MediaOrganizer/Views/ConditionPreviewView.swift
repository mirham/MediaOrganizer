//
//  ActionPreviewView.swift
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
            Text("Example: ")
                .font(.subheadline)
            ForEach(conditionElements, id: \.id) { elementInfo in
                let elementOptions = getElementOptionsByTypeId(typeId: elementInfo.elementTypeId)
                switch elementInfo.settingType {
                    case .date:
                        HStack(spacing: 0) {
                            Text(getFormattedDate(elementInfo: elementInfo))
                        }
                        .font(.subheadline)
                        .background(
                            RoundedRectangle(cornerRadius: 2, style: .continuous)
                                .fill(elementOptions.background)
                        )
                    default:
                        HStack(spacing: 0) {
                            Text(MetadataType(rawValue: elementInfo.elementTypeId)?.example
                                 ?? elementInfo.displayText)
                        }
                        .font(.subheadline)
                        .background(
                            RoundedRectangle(cornerRadius: 2, style: .continuous)
                                .fill(elementOptions.background)
                        )
                }
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
