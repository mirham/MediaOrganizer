//
//  RulesEditView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import SwiftUI

struct RulesEditView: View {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.controlActiveState) private var controlActiveState
    
    private let ruleService = RuleService.shared
    
    var body: some View {
        ScrollView(.vertical) {
            ForEach(appState.current.job?.rules ?? [Rule](), id: \.id) { rule in
                VStack(alignment: .leading) {
                    Text(Constants.elConditions)
                        .asRuleElementCaption()
                    HStack {
                        Button(String(), systemImage: Constants.iconAdd) {
                            // Conditions
                        }
                        .withAddButtonStyle(activeState: controlActiveState)
                        .isHidden(hidden: !ruleService.isCurrentRule(ruleId: rule.id) , remove: true)
                        VStack(alignment: .leading) {
                            Text(Constants.elNoConditions)
                                .asRuleElementNone()
                                .isHidden(hidden: isNoneElementSholuldBeHidden(rule: rule, array: rule.conditions), remove: true)
                        }
                    }
                    Text(Constants.elActions)
                        .asRuleElementCaption()
                    HStack(alignment: .bottom) {
                        Button(String(), systemImage: Constants.iconAdd) {
                            rule.actions.append(Action())
                        }
                        .withAddButtonStyle(activeState: controlActiveState)
                        .isHidden(hidden: !ruleService.isCurrentRule(ruleId: rule.id) , remove: true)
                        .padding(.bottom, 3)
                        VStack(alignment: .leading) {
                            Text(Constants.elNoActions)
                                .asRuleElementNone()
                                .isHidden(hidden: isNoneElementSholuldBeHidden(rule: rule, array: rule.actions), remove: true)
                            ForEach(rule.actions, id: \.id) { action in
                                HStack(spacing: 0) {
                                    ActionView(action: action)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    }
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

