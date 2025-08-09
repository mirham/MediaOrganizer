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
        guard let currentRule = appState.current.rule
        else { return }
        
        currentRule.actions.append(Action())
    }
    
    func isCurrentAction(actionId: UUID) -> Bool {
        guard let currentAction = appState.current.action
        else { return false }
        
        let result = currentAction.id == actionId
        
        return result
    }
    
    func actionToFileAction(action: Action, fileInfo: MediaFileInfo) -> FileAction? {
        var value: String = String()
        
        for element in action.elements {
            element.fileMetadata = fileInfo.metadata
            
            guard let stringElement = elementService.elementAsString(element: element)
            else { return nil }
            
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
        guard let currentRule = appState.current.rule
        else { return }
        
        if let actionIndex = currentRule.actions.firstIndex(where: { $0.id == actionId })  {
            currentRule.actions[actionIndex] = action
            appState.current.refreshSignal.toggle()
        }
    }
    
    func removeActionById(actionId: UUID) {
        guard let currentRule = appState.current.rule
        else { return }
        
        if let actionIndex = currentRule.actions.firstIndex(where: { $0.id == actionId }) {
            currentRule.actions.remove(at: actionIndex)
            appState.current.refreshSignal.toggle()
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
