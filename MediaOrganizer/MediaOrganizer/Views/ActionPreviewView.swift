//
//  ActionPreviewView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 05.10.2024.
//

import SwiftUI
import WrappingHStack

struct ActionPreviewView: View {
    @EnvironmentObject var appState: AppState
    
    var actionElements: [ElementInfo]
    
    private let dateFormatter = DateFormatter()
    private let dateExample = Date.now
    
    var body: some View {
        WrappingHStack(alignment: .leading, horizontalSpacing: 0) {
            Text("Example: ")
            ForEach(actionElements, id: \.id) {elementInfo in
                if (elementInfo.settingType != nil) {
                    switch elementInfo.settingType! {
                        case .date:
                            if(elementInfo.customDate != nil){
                                HStack(spacing: 0) {
                                    Text("[")
                                        .foregroundStyle(.gray)
                                    Text(getFormattedDate(elementInfo: elementInfo))
                                    Text("]")
                                        .foregroundStyle(.gray)
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                                        .fill(elementInfo.elementOptions.background)
                                )
                            }
                            else
                            {
                                HStack(spacing: 0) {
                                    Text("[")
                                        .foregroundStyle(.gray)
                                    Text(elementInfo.displayText)
                                    Text("(example:\(getFormattedDate(elementInfo: elementInfo)))")
                                    Text("]")
                                        .foregroundStyle(.gray)
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                                        .fill(elementInfo.elementOptions.background)
                                )
                            }

                        default:
                            HStack(spacing: 0) {
                                Text("[")
                                    .foregroundStyle(.gray)
                                Text(elementInfo.customText ?? elementInfo.displayText)
                                Text("]")
                                    .foregroundStyle(.gray)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 2, style: .continuous)
                                    .fill(elementInfo.elementOptions.background)
                            )
                    }
                }
            }
        }
        .opacity(0.6)
        .frame(maxWidth: .infinity)
        .isHidden(hidden: actionElements.isEmpty, remove: false)
    }
    
    // MARK: Private functions
    
    private func getFormattedDate(elementInfo: ElementInfo) -> String {
        dateFormatter.dateFormat = DateFormatType(rawValue: elementInfo.selectedTypeId ?? DateFormatType.dateEu.id)!.formula
        let date = elementInfo.customDate == nil || elementInfo.customDate == Date.distantPast
            ? dateExample
            : elementInfo.customDate!
        let result = dateFormatter.string(from: date)
        
        return result
    }
}
