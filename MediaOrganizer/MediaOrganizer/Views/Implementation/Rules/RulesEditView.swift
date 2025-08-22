//
//  RulesEditView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import SwiftUI
import Factory

struct RulesEditView: ColorThemeSupportedView {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.controlActiveState) private var controlActiveState
    @Environment(\.colorScheme) private var colorScheme
    
    @Injected(\.ruleService) private var ruleService
    @Injected(\.conditionService) private var conditionService
    @Injected(\.actionService) private var actionService
    
    @State private var selectedRuleId: UUID? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: Constants.iconInfo)
                    .asInfoIcon()
                Text(Constants.hintRules)
            }
            .opacity(0.7)
            .padding(5)
            if appState.current.job?.rules.isEmpty ?? true {
                buildNoRulesStub()
            }
            else {
                ScrollView(.vertical) {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(Array(appState.current.job?.rules.enumerated() ?? [Rule]().enumerated()), id: \.element.id) { index, rule in
                            HStack {
                                Text("\(index + 1)")
                                    .asRuleNumber()
                                Divider()
                                    .padding(.trailing, 5)
                                VStack(alignment: .center) {
                                    buildConditions(rule: rule)
                                    buildActions(rule: rule)
                                    ValidationMessageView(
                                        text: rule.validation.message ?? String(),
                                        severity: rule.validation.severity ?? .error,
                                        hideFunc: { return rule.validation.message == nil })
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .onAppear(perform: { rule.number = index + 1})
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(selectedRuleId == rule.id
                                        && ruleService.isCurrentRule(ruleId: rule.id)
                                        && !appState.current.isRuleInSetupMode
                                        ? Color.blue.opacity(0.3)
                                        : (index % 2 == 0 ? Color.gray.opacity(0.08) : Color.clear))
                            .contentShape(Rectangle())
                            .simultaneousGesture(
                                TapGesture()
                                    .onEnded {
                                        handleRuleItemClick(rule: rule)
                                    }
                            )
                            .disabled(isRuleShouldBeDisabled(ruleId: rule.id))
                            DividerWithImage()
                                .isHidden(hidden: ruleService.getRuleIndexByRuleId(ruleId: rule.id)! == appState.current.job!.rules.count - 1, remove: true)
                        }
                    }
                }
                .onChange(of: appState.current.refreshSignal, setupCloseButton)
            }
        }
        .safeAreaInset(edge: .bottom, content: {
            VStack {
                Divider()
                HStack {
                    RulesToolbarView()
                }
                .padding(.bottom, 5)
                .frame(maxWidth: .infinity)
            }
            .background(getPanelColor(colorScheme: colorScheme))
        })
    }
    
    // MARK: Private functions
    
    @ViewBuilder
    private func buildNoRulesStub() -> some View {
        Spacer()
        HStack {
            Spacer()
            Text(Constants.elNoRules)
                .textCase(.uppercase)
                .foregroundColor(.gray.opacity(0.5))
                .padding()
            Spacer()
        }
        Spacer()
    }
    
    @ViewBuilder
    private func buildConditions(rule: Rule) -> some View {
        Text(Constants.elConditions)
            .asRuleElementCaption()
            .padding(.top, 5)
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(Constants.elNoConditions)
                    .asRuleElementNone()
                    .isHidden(
                        hidden: isNoneElementSholuldBeHidden(rule: rule, array: rule.conditions),
                        remove: true)
                ForEach(rule.conditions, id: \.id) { condition in
                    HStack(spacing: 0) {
                        ConditionView(ruleId: rule.id, condition: condition)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        Button(String(),systemImage: Constants.iconAdd) {
            handleAddConditionButtonClick(rule: rule)
        }
        .withSmallAddButtonStyle(activeState: controlActiveState)
        .isHidden(hidden: isAddButtonShouldBeHidden(ruleId: rule.id) , remove: true)
        .padding(.top, 3)
        .padding(.bottom, 5)
        .offset(x: -20)
    }
    
    @ViewBuilder
    private func buildActions(rule: Rule) -> some View {
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
        .onChange(of: appState.current.rule, {
            selectedRuleId = appState.current.rule?.id ?? nil
        })
        .padding(.bottom, 5)
        Button(String(), systemImage: Constants.iconAdd) {
            handleAddActionButtonClick(rule: rule)
        }
        .withSmallAddButtonStyle(activeState: controlActiveState)
        .isHidden(hidden: isAddButtonShouldBeHidden(ruleId: rule.id) , remove: true)
        .padding(.bottom, 3)
        .offset(x: -20)
    }
    
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
    
    private func handleAddConditionButtonClick(rule: Rule) {
        conditionService.addNewCondition()
        validateRule(rule: rule)
    }
    
    private func handleAddActionButtonClick(rule: Rule) {
        actionService.addNewAction()
        validateRule(rule: rule)
    }
    
    private func isNoneElementSholuldBeHidden(rule: Rule, array: [Any]) -> Bool {
        return !array.isEmpty
                || (appState.current.rule != nil
                    && appState.current.rule!.id == rule.id)
    }
    
    private func isAddButtonShouldBeHidden(ruleId: UUID) -> Bool {
        return !ruleService.isCurrentRule(ruleId: ruleId)
            || appState.current.isRuleInSetupMode
    }
    
    private func isRuleShouldBeDisabled(ruleId: UUID) -> Bool {
        return !ruleService.isCurrentRule(ruleId: ruleId)
            && appState.current.isRuleInSetupMode
    }
    
    private func validateRule(rule: Rule) {
        ruleService.validateRule(rule: rule)
        appState.current.refreshSignal.toggle()
    }
    
    private func setupCloseButton() {
        let isEnabled = appState.current.allRulesValid
            && appState.current.isRuleSetupComplete
            && appState.current.isRuleElementSetupComplete
            && appState.current.validationMessage == nil
        
        ViewHelper.setUpCloseViewButton(
            viewName: Constants.windowIdJobSettings,
            enable: isEnabled)
    }
}

private extension Text {
    func asRuleNumber() -> some View {
        self.fontWeight(.bold)
        .font(.system(size: 20))
        .frame(maxWidth: 14)
        .padding(5)
        .foregroundStyle(.gray.opacity(0.3))
    }
    
    func asRuleElementCaption() -> some View {
        self.textCase(.uppercase)
        .font(.system(size: 9))
        .foregroundStyle(.gray)
        .frame(maxWidth: .infinity, alignment: .center)
        .offset(x: -20)
    }
    
    func asRuleElementNone() -> some View {
        self.textCase(.uppercase)
            .font(.system(size: 11))
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(5)
            .offset(x: -20)
    }
}

