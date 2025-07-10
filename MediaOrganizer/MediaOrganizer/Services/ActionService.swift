//
//  ActionService.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 02.10.2024.
//

import Foundation
import Factory

class ActionService : ServiceBase, ActionServiceType {
    @Injected(\.elementService) private var elementService
    
    private let dateFormatter: DateFormatter
    private let dateExample: Date
    
    override init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.defaultValidationDateFormat
        
        if let dateExample = dateFormatter.date(from: Constants.dateMaxValueString) {
            self.dateExample = dateExample
        }
        else {
            self.dateExample = Date.distantFuture
        }
        
        super.init()
    }
    
    func addNewAction() {
        appState.current.rule!.actions.append(Action())
    }
    
    func isCurrentAction(actionId: UUID) -> Bool {
        guard doesCurrentActionExist() else { return false }
        
        let result = appState.current.action!.id == actionId
        
        return result
    }
    
    func actionToFileAction(action: Action, fileInfo: MediaFileInfo) -> FileAction {
        var value: String = String()
        
        for element in action.elements {
            element.fileMetadata = fileInfo.metadata
            guard let stringElement = elementService.elementAsString(element: element)
            else { return FileAction(actionType: .skip, value: nil) }
            
            value.append(stringElement)
        }
        
        return FileAction(actionType: action.type, value: value)
    }
    
    func actionToExampleString(action: Action) -> String {
        var result: String = String()
        
        for element in action.elements {
            switch element.settingType {
                case .date:
                    result.append(getFormattedDate(element: element))
                default:
                    let stringExample = MetadataType(rawValue: element.elementTypeId)?.example
                        ?? element.customText
                        ?? element.displayText
                    result.append(stringExample)
            }
        }
        
        return result
    }
    
    func replaceAction(actionId: UUID, action: Action) {
        guard appState.current.rule != nil else { return }
        
        if let actionIndex = appState.current.rule!.actions.firstIndex(where: { $0.id == actionId })  {
            appState.current.rule!.actions[actionIndex] = action
            
            appState.objectWillChange.send()
        }
    }
    
    func removeActionById(actionId: UUID) {
        guard appState.current.rule != nil else { return }
        
        if let actionIndex = appState.current.rule!.actions.firstIndex(where: { $0.id == actionId }) {
            appState.current.rule!.actions.remove(at: actionIndex)
            appState.objectWillChange.send()
        }
    }
    
    // MARK: Private functions
    
    private func getFormattedDate(element: ActionElement) -> String {
        dateFormatter.dateFormat = (element.selectedDateFormatType
            ?? DateFormatType.dateEu)!.formula
        let date = element.customDate == nil || element.customDate == Date.distantPast
            ? dateExample
            : element.customDate!
        
        var result = dateFormatter.string(from: date)
        
        if result.contains(where: {$0 == Constants.slashChar}) {
            result = result.replacing(Constants.regexSlash, with: Constants.colon)
        }
        
        return result
    }
}
