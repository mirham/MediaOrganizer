//
//  ActionEditView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import SwiftUI

struct ActionEditView: View {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.controlActiveState) private var controlActiveState
    
    private let ruleService = RuleService.shared
    
    @State private var selection: Int = ActionType.rename.rawValue
    
    var body: some View {
        VStack {
            Picker(String(), selection: Binding(
                get: { appState.current.action!.type.rawValue },
                set: {
                    print(ActionType(rawValue: $0)!.description)
                    appState.current.action!.type = ActionType(rawValue: $0) ?? .rename
                    appState.objectWillChange.send()
                })) {
                ForEach(ActionType.allCases, id: \.id) { item in
                    Text(item.description)
                }
            }
            .pickerStyle(.menu)
        }
    }
    
    // MARK: Private functions
    
    private func ruleItemClickHandler (rule : Rule) {
        appState.current.rule = rule
    }
    
    private func ruleItemDoubleClickHandler (rule : Rule) {
        appState.current.rule = rule
        // RUSS: Entering edit rule mode
    }
}

