//
//  ActionView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import SwiftUI
import Factory

struct ActionView: ElementContainerView {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.controlActiveState) private var controlActiveState
    @Environment(\.colorScheme) private var colorScheme
    
    @Injected(\.ruleService) private var ruleService
    @Injected(\.actionService) private var actionService
    @Injected(\.validationService) private var validationService
    
    @State private var showEditor: Bool = false
    @State private var prevAction: Action?
    
    private var ruleId: UUID
    private var action: Action
    
    init(ruleId: UUID, action: Action) {
        self.action = action
        self.ruleId = ruleId
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                let elementOptions = getElementOptionsByTypeId(
                    typeId: action.type.id,
                    colorScheme: colorScheme)
                Text(action.description())
                    .fontWeight(.bold)
                    .frame(maxWidth: 100, alignment: .center)
                    .contentShape(Rectangle())
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 3, style: .continuous)
                            .fill(elementOptions.background)
                            .padding(3)
                    )
                    .isHidden(hidden: showEditor, remove: true)
                ActionEditView()
                    .padding(5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .isHidden(hidden: !showEditor || !actionService.isCurrentAction(actionId: action.id), remove: true )
                ActionPreviewView(actionElements: action.elements)
                    .isHidden(hidden: showEditor || !action.type.canBeCustomized, remove: showEditor)
                    .frame(maxWidth: .infinity,  alignment: .leading)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .onChange(of: action.elements, resetValidationMessage)
                HStack {
                    Button(String(), systemImage: Constants.iconCheck, action: handleSaveClick)
                        .withSmallSaveButtonStyle(activeState: controlActiveState)
                    Button(String(), systemImage: Constants.iconCancel, action: hanldeCancelClick)
                        .withSmallDestructiveButtonStyle(activeState: controlActiveState)
                }
                .isHidden(hidden: !showEditor, remove: true )
                HStack {
                    Button(String(), systemImage: Constants.iconEdit, action: handeEditClick)
                        .withSmallEditButtonStyle(activeState: controlActiveState)
                    Button(String(), systemImage: Constants.iconRemove, action: handleRemoveClick)
                        .withSmallDestructiveButtonStyle(activeState: controlActiveState)
                }
                .isHidden(hidden: shouldActionButtonBeHidden(ruleId: ruleId), remove: true )
            }
            .onDisappear() {
                appState.current.refreshSignal.toggle()
            }
            .background(actionService.isCurrentAction(actionId: action.id) && appState.current.isActionInEditMode
                        ? Color.blue.opacity(0.3)
                        : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
    
    // MARK: Private functions
    
    private func handeEditClick () {
        self.prevAction = action.clone()
        enterEditMode()
    }
    
    private func handleSaveClick() {
        guard isValidAction() else { return }
        guard let currentActionType = appState.current.action?.type else { return }
        
        let cleanUpElements = currentActionType == ActionType.skip
            || currentActionType == ActionType.delete
        
        if cleanUpElements {
            appState.current.action?.elements.removeAll()
        } else {
            if let actionIndex = appState.current.rule!.actions
                .firstIndex(where: {$0.id == appState.current.action!.id}) {
                appState.current.rule!.actions[actionIndex].elements
                = appState.current.action!.elements
            }
        }
        
        exitEditMode()
    }
    
    private func hanldeCancelClick() {
        if let prevAction = prevAction {
            actionService.replaceAction(
                actionId: action.id,
                action: prevAction)
            resetValidationMessage()
            exitEditMode()
        }
    }
    
    private func handleRemoveClick () {
        actionService.removeActionById(actionId: action.id)
        ruleService.validateRule(rule: appState.current.rule)
        exitEditMode()
        appState.current.refreshSignal.toggle()
    }
    
    private func shouldActionButtonBeHidden(ruleId: UUID) -> Bool {
        return !ruleService.isCurrentRule(ruleId: ruleId)
            || appState.current.isConditionInEditMode
            || appState.current.isActionInEditMode
    }
    
    private func isValidAction() -> Bool {
        guard !appState.current.isActionElementInEditMode
        else {
            appState.current.validationMessage = Constants.vmFinishEditing
            
            return false
        }
        
        guard hasAllSetupElements() else { return false }
        guard isValidFileAction() else { return false }
        guard appState.current.validationMessage == nil else { return false }
        
        return true
    }
    
    private func hasAllSetupElements() -> Bool {
        for element in appState.current.action!.elements {
            if !element.hasValue() {
                appState.current.validationMessage = Constants.vmSetupElements
                
                return false
            }
        }
        
        return true
    }
    
    private func isValidFileAction() -> Bool {
        guard let currentAction = appState.current.action else {
            return false
        }
        
        let fileActionExample = actionService.actionToExampleString(action: currentAction)
        
        switch currentAction.type {
            case .rename:
                return isValidFileName(fileName: fileActionExample)
            case .copyToFolder, .moveToFolder:
                return isValidFolderPath(folderPath: fileActionExample)
            default:
                return true
        }
    }
    
    private func isValidFileName(fileName: String) -> Bool {
        let validationResult = validationService.isValidFilename(input: fileName)
        
        return processValidationResult(validationResult: validationResult)
    }
    
    private func isValidFolderPath(folderPath: String) -> Bool {
        guard let parentFolderPath = appState.current.job?.outputFolder else {
            return false
        }
        
        let validationResult = validationService.isValidFolderPath(
            input: folderPath,
            parentFolderPathLength: parentFolderPath.count)
        
        return processValidationResult(validationResult: validationResult)
    }
    
    private func processValidationResult<T>(validationResult: ValidationResult<T>) -> Bool {
        if !validationResult.isValid {
            appState.current.validationMessage = validationResult.message
            ViewHelper.setUpCloseViewButton(
                viewName: Constants.windowIdJobSettings,
                enable: false)
            
            return false
        }
        
        return true
    }
    
    private func enterEditMode() {
        appState.current.action = action
        appState.current.isActionInEditMode = true
        showEditor = true
    }
    
    private func exitEditMode() {
        appState.current.isActionInEditMode = false
        appState.current.isActionElementInEditMode = false
        showEditor = false
    }
    
    private func resetValidationMessage() {
        appState.current.validationMessage = nil
    }
}

