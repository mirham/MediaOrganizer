//
//  ConditionView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import SwiftUI
import Factory

struct ConditionView: ElementContainerView {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.controlActiveState) private var controlActiveState
    @Environment(\.colorScheme) private var colorScheme
    
    @Injected(\.ruleService) private var ruleService
    @Injected(\.conditionService) private var conditionService
    @Injected(\.elementStrategyFactory) private var elementStrategyFactory
    
    @State private var showEditor: Bool = false
    @State private var prevCondition: Condition?
    
    private var ruleId: UUID
    private var condition: Condition
    
    init(ruleId: UUID, condition: Condition) {
        self.condition = condition
        self.ruleId = ruleId
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                let elementOptions = getElementOptionsByTypeId(
                    typeId: condition.type.id,
                    colorScheme: colorScheme)
                Text(condition.description())
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
                ConditionEditView()
                    .padding(5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .isHidden(hidden: !showEditor || !conditionService.isCurrentCondition(conditionId: condition.id), remove: true )
                ConditionPreviewView(conditionElements: condition.elements)
                    .isHidden(hidden: showEditor, remove: showEditor)
                    .frame(maxWidth: .infinity,  alignment: .leading)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .onChange(of: condition.elements, resetValidationMessage)
                HStack {
                    Button(String(), systemImage: Constants.iconCheck, action: handleSaveClick)
                        .withSmallSaveButtonStyle(activeState: controlActiveState)
                    Button(String(), systemImage: Constants.iconCancel, action: hanldeCancelClick)
                        .withSmallDestructiveButtonStyle(activeState: controlActiveState)
                }
                .isHidden(hidden: !showEditor, remove: true )
                HStack {
                    Button(String(), systemImage: Constants.iconEdit, action: handleEditClick)
                        .withSmallEditButtonStyle(activeState: controlActiveState)
                    Button(String(), systemImage: Constants.iconRemove, action: handleRemoveClick)
                        .withSmallDestructiveButtonStyle(activeState: controlActiveState)
                }
                .isHidden(hidden: shouldActionButtonBeHidden(ruleId: ruleId), remove: true )
            }
            .onDisappear() {
                appState.current.refreshSignal.toggle()
            }
            .background(conditionService.isCurrentCondition(conditionId: condition.id) && appState.current.isConditionInEditMode
                        ? Color.blue.opacity(0.3)
                        : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
    
    // MARK: Private functions
    
    private func handleEditClick() {
        self.prevCondition = condition.clone()
        enterEditMode()
    }
    
    private func handleSaveClick() {
        guard isValidCondition() else {
            return
        }
        
        if let conditionIndex = appState.current.rule!.conditions.firstIndex(where: {$0.id == appState.current.condition!.id}) {
            appState.current.rule!.conditions[conditionIndex].elements
            = appState.current.condition!.elements
        }
        
        exitEditMode()
    }
    
    private func hanldeCancelClick() {
        if let prevCondition = prevCondition {
            conditionService.replaceCondition(
                conditionId: condition.id,
                condition: prevCondition)
            resetValidationMessage()
            exitEditMode()
        }
    }
    
    private func handleRemoveClick() {
        conditionService.removeConditionById(conditionId: condition.id)
        ruleService.validateRule(rule: appState.current.rule)
        appState.current.isConditionInEditMode = false
        showEditor = false
    }
    
    private func shouldActionButtonBeHidden(ruleId: UUID) -> Bool {
         return !ruleService.isCurrentRule(ruleId: ruleId)
                || appState.current.isConditionInEditMode
                || appState.current.isActionInEditMode
    }
    
    private func isValidCondition() -> Bool {
        guard !appState.current.isConditionElementInEditMode
        else {
            appState.current.validationMessage = Constants.vmFinishEditing
            
            return false
        }
        
        guard hasAllSetupElements() else { return false }
        guard isValidExpression() else { return false }
        guard appState.current.validationMessage == nil else { return false }
        
        return true
    }
    
    private func hasAllSetupElements() -> Bool {
        for element in appState.current.condition!.elements {
            if !element.hasValue() {
                appState.current.validationMessage = Constants.vmSetupElements
                
                return false
            }
        }
        
        return true
    }
    
    private func isValidExpression() -> Bool {
        do {
            resetValidationMessage()
            let parser = ExpressionParser(elements: appState.current.condition!.elements)
            _ = try parser.parse()
        }
        catch let astError as ASTError {
            appState.current.validationMessage = astError.errorDescription
            
            return false
        }
        catch {
            appState.current.validationMessage = String(
                format: Constants.vmExpressionParsingError,
                error.localizedDescription)
            
            return false
        }
        
        return true
    }
    
    private func enterEditMode() {
        appState.current.condition = condition
        appState.current.isConditionInEditMode = true
        showEditor = true
    }
    
    private func exitEditMode() {
        appState.current.isConditionInEditMode = false
        appState.current.isConditionElementInEditMode = false
        showEditor = false
    }
    
    private func resetValidationMessage() {
        appState.current.validationMessage = nil
    }
}
