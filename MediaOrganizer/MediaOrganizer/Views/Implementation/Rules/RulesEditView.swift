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
                    Button(String(), systemImage: Constants.iconAdd) {
                        conditionService.addNewCondition()
                    }
                    .withAddButtonStyle(activeState: controlActiveState)
                    .isHidden(hidden: !ruleService.isCurrentRule(ruleId: rule.id) , remove: true)
                    .padding(.bottom, 3)
                    Text(Constants.elActions)
                        .asRuleElementCaption()
                        .padding(.top, 5)
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
                    Button(String(), systemImage: Constants.iconAdd) {
                        actionService.addNewAction()
                    }
                    .withAddButtonStyle(activeState: controlActiveState)
                    .isHidden(hidden: !ruleService.isCurrentRule(ruleId: rule.id) , remove: true)
                    .padding(.bottom, 3)
                }
                .padding(5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .background(ruleService.isCurrentRule(ruleId: rule.id) && !appState.current.isActionInEditMode ? Color(hex: Constants.colorHexSelection) : .clear)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .simultaneousGesture(TapGesture().onEnded {
                    ruleItemClickHandler(rule: rule)
                })
                DividerWithImage(imageName: Constants.iconArrowDown, color: Color.gray)
                    .isHidden(hidden: ruleService.getRuleIndexByRuleId(ruleId: rule.id)! == appState.current.job!.rules.count - 1, remove: true)
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
            .background(Color(hex: Constants.colorHexPanelDark))
        })
        .onDisappear() {
            appState.current.isActionInEditMode = false
        }
    }
    
    // MARK: Private functions
    
    private func ruleItemClickHandler (rule : Rule) {
        if appState.current.rule != rule {
            appState.current.condition = nil
            appState.current.action = nil
        }
        
        appState.current.rule = rule
    }
    
    private func isNoneElementSholuldBeHidden(rule : Rule, array: [Any]) -> Bool {
        let result = !array.isEmpty || (appState.current.rule != nil && appState.current.rule!.id == rule.id)
        
        return result
    }
}

private extension Button {
    func withRuleButtonStyle(activeState: ControlActiveState) -> some View {
        self.buttonStyle(.plain)
            .focusEffectDisabled()
            .font(.system(size: 16))
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

