//
//  ActionView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import SwiftUI

struct ActionView: View {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.controlActiveState) private var controlActiveState
    
    @State private var showEditor: Bool = false
    
    private var action: Action
    
    init(action: Action) {
        self.action = action
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(action.description())
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .padding(5)
                .onTapGesture(count: 2) {
                    actionClickHandler()
                    actionDoubleClickHandler()
                }
                .onTapGesture {
                    actionClickHandler()
                }
                .isHidden(hidden: showEditor, remove: true)
            ActionEditView()
                .padding(.leading, -15)
                .padding(5)
                .onDisappear() {
                    showEditor = false
                }
                .frame(maxWidth: .infinity)
                .isHidden(hidden: !showEditor || !isActionSelected(), remove: true )
        }
    }
    
    // MARK: Private functions
    
    private func actionClickHandler () {
        appState.current.action = action
    }
    
    private func actionDoubleClickHandler () {
        showEditor = true
    }
    
    private func isActionSelected() -> Bool {
        let result = appState.current.action != nil && appState.current.action!.id == action.id
        
        return result
    }
}

