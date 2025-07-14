//
//  RulesEditView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import SwiftUI
import Factory

struct RulesEditView: View {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.controlActiveState) private var controlActiveState
    
    @Injected(\.ruleService) private var ruleService
    @Injected(\.conditionService) private var conditionService
    @Injected(\.actionService) private var actionService
    
    var body: some View {
        ScrollView(.vertical) {
            ForEach(appState.current.job?.rules ?? [Rule](), id: \.id) { rule in
                VStack(alignment: .center) {
                    Text(Constants.elConditions)
                        .asRuleElementCaption()
                        .padding(.top, 5)
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text(Constants.elNoConditions)
                                .asRuleElementNone()
                                .isHidden(hidden: isNoneElementSholuldBeHidden(rule: rule, array: rule.conditions), remove: true)
                            ForEach(rule.conditions, id: \.id) { condition in
                                HStack(spacing: 0) {
                                    ConditionView(ruleId: rule.id, condition: condition)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    }
                    Button(String(),systemImage: Constants.iconAdd, action: handleAddConditionButtonClick)
                    .withAddButtonStyle(activeState: controlActiveState)
                    .isHidden(hidden: isAddButtonShouldBeHidden(ruleId: rule.id) , remove: true)
                    .padding(.top, 3)
                    .padding(.leading, 10)
                    .padding(.bottom, 5)
                    Text(Constants.elActions)
                        .asRuleElementCaption()
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text(Constants.elNoActions)
                                .asRuleElementNone()
                                .isHidden(hidden: isNoneElementSholuldBeHidden(rule: rule, array: rule.actions), remove: true)
                            ForEach(rule.actions, id: \.id) { action in
                                HStack(spacing: 0) {
                                    ActionView(ruleId: rule.id, action: action)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    }
                    .onAppear(perform: { validateRule(rule: rule) })
                    .padding(.bottom, 5)
                    ValidationMessageView(
                        text: rule.validationMessage ?? String(),
                        hideFunc: { return rule.validationMessage == nil })
                    Button(String(), systemImage: Constants.iconAdd) {
                        handleAddActionButtonClick(rule: rule)
                    }
                    .withAddButtonStyle(activeState: controlActiveState)
                    .isHidden(hidden: isAddButtonShouldBeHidden(ruleId: rule.id) , remove: true)
                    .padding(.leading, 10)
                    .padding(.bottom, 3)
                }
                .padding(5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .background(ruleService.isCurrentRule(ruleId: rule.id)
                            && !appState.current.isActionInEditMode
                            ? Color(hex: Constants.colorHexSelection)
                            : .clear)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .simultaneousGesture(
                    TapGesture()
                        .onEnded {
                            handleRuleItemClick(rule: rule)
                        }
                )
                .disabled(isRuleShouldBeDisabled(ruleId: rule.id))
                DividerWithImage(imageName: Constants.iconArrowDown, color: Color.gray)
                    .isHidden(hidden: ruleService.getRuleIndexByRuleId(ruleId: rule.id)! == appState.current.job!.rules.count - 1, remove: true)
            }
        }
        .onChange(of: appState.current.refreshSignal, setupCloseButton)
        .safeAreaInset(edge: .bottom, content: {
            VStack {
                Divider()
                HStack {
                    RulesToolbarView()
                }
                .padding(.bottom, 5)
                .frame(maxWidth: .infinity)
            }
            .background(Color(hex: Constants.colorHexPanelDark))
        })
    }
    
    // MARK: Private functions
    
    private func handleRuleItemClick(rule: Rule) {
        guard !appState.current.isActionInEditMode
                || !appState.current.isConditionInEditMode
        else { return }
        
        if appState.current.rule != rule {
            appState.current.condition = nil
            appState.current.action = nil
        }
        
        appState.current.rule = rule
    }
    
    private func handleAddConditionButtonClick() {
        conditionService.addNewCondition()
    }
    
    private func handleAddActionButtonClick(rule: Rule) {
        actionService.addNewAction()
        validateRule(rule: rule)
        setupCloseButton()
    }
    
    private func isNoneElementSholuldBeHidden(rule: Rule, array: [Any]) -> Bool {
        return !array.isEmpty
                || (appState.current.rule != nil
                    && appState.current.rule!.id == rule.id)
    }
    
    private func isAddButtonShouldBeHidden(ruleId: UUID) -> Bool {
        return !ruleService.isCurrentRule(ruleId: ruleId)
            || appState.current.isConditionInEditMode
            || appState.current.isActionInEditMode
    }
    
    private func isRuleShouldBeDisabled(ruleId: UUID) -> Bool {
        return !ruleService.isCurrentRule(ruleId: ruleId)
            && (appState.current.isConditionInEditMode || appState.current.isActionInEditMode)
    }
    
    private func validateRule(rule: Rule) {
        ruleService.validateRule(rule: rule)
        appState.current.refreshSignal.toggle()
    }
    
    private func setupCloseButton() {
        ViewHelper.setUpCloseViewButton(
            viewName: Constants.windowIdJobSettings,
            enable: appState.current.allRulesValid)
    }
}

private extension Button {
    func withRuleButtonStyle(activeState: ControlActiveState) -> some View {
        self.buttonStyle(.plain)
            .focusEffectDisabled()
            .opacity(getViewOpacity(state: activeState))
    }
    
    func withAddButtonStyle(activeState: ControlActiveState) -> some View {
        self.withRuleButtonStyle(activeState: activeState)
            .foregroundStyle(.green)
    }
    
    func withRemoveButtonStyle(activeState: ControlActiveState) -> some View {
        self.withRuleButtonStyle(activeState: activeState)
            .foregroundStyle(.red)
    }
}

private extension Text {
    func asRuleElementCaption() -> some View {
        self.textCase(.uppercase)
        .font(.system(size: 9))
        .foregroundStyle(.gray)
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    func asRuleElementNone() -> some View {
        self.textCase(.uppercase)
            .font(.system(size: 11))
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(5)
    }
}

