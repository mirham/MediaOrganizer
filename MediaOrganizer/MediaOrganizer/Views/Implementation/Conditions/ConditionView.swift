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
    
    @Injected(\.ruleService) private var ruleService
    @Injected(\.conditionService) private var conditionService
    
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
                let elementOptions = getElementOptionsByTypeId(typeId: condition.type.id)
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
                    .onChange(of: condition.elements, {  })
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
            .background(conditionService.isCurrentCondition(conditionId: condition.id) && appState.current.isConditionInEditMode
                        ? Color(hex: Constants.colorHexSelection)
                        : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    // MARK: Private functions
    
    private func handleEditClick() {
        self.prevCondition = condition.clone()
        appState.current.condition = condition
        appState.current.isConditionInEditMode = true
        showEditor = true
    }
    
    private func handleSaveClick() {
        appState.current.isConditionInEditMode = false
        showEditor = false
    }
    
    private func hanldeCancelClick() {
        if let prevCondition = prevCondition {
            conditionService.replaceCondition(
                conditionId: condition.id,
                condition: prevCondition)
            appState.current.isConditionInEditMode = false
            showEditor = false
        }
    }
    
    private func handleRemoveClick() {
        conditionService.removeConditionById(conditionId: condition.id)
        appState.current.isConditionInEditMode = false
        showEditor = false
    }
    
    private func shouldActionButtonBeHidden(ruleId: UUID) -> Bool {
         return !ruleService.isCurrentRule(ruleId: ruleId)
                || appState.current.isConditionInEditMode
                || appState.current.isActionInEditMode
    }
}

