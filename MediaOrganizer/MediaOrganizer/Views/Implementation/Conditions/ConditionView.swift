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
    
    @State private var showEditor: Bool = false
    
    @Injected(\.ruleService) private var ruleService
    @Injected(\.conditionService) private var conditionService
    
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
                Button(String(), systemImage: Constants.iconEdit, action: conditionEditClickHandler)
                    .withSmallEditButtonStyle(activeState: controlActiveState)
                    .isHidden(hidden: !ruleService.isCurrentRule(ruleId: ruleId) || appState.current.isConditionInEditMode, remove: true )
                Button(String(), systemImage: Constants.iconCheck, action: conditionSaveClickHanlder)
                    .withSmallSaveButtonStyle(activeState: controlActiveState)
                    .isHidden(hidden: !showEditor, remove: true )
                Button(String(), systemImage: Constants.iconRemove, action: conditionRemoveClickHandler)
                    .withSmallRemoveButtonStyle(activeState: controlActiveState)
                    .isHidden(hidden: !ruleService.isCurrentRule(ruleId: ruleId), remove: true )
            }
            .background(conditionService.isCurrentCondition(conditionId: condition.id) && appState.current.isConditionInEditMode
                        ? Color(hex: Constants.colorHexSelection)
                        : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    // MARK: Private functions
    
    private func conditionEditClickHandler () {
        appState.current.condition = condition
        appState.current.isConditionInEditMode = true
        showEditor = true
    }
    
    private func conditionSaveClickHanlder() {
        appState.current.isConditionInEditMode = false
        showEditor = false
    }
    
    private func conditionRemoveClickHandler () {
        conditionService.removeConditionById(conditionId: condition.id)
        appState.current.isConditionInEditMode = false
        showEditor = false
    }
}

