//
//  ValidationMessageView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 08.07.2025.
//

import SwiftUI

struct ValidationMessageView : View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: Constants.iconWarning)
                Text(appState.current.validationMessage ?? String())
            }
        }
        .asValidationMessage()
        .isHidden(hidden: appState.current.validationMessage == nil, remove: true)
    }
}

private extension VStack {
    func asValidationMessage() -> some View {
        self.frame(minWidth: 400, maxWidth: .infinity, minHeight: 20)
            .background(
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(.red)
            )
            .contentShape(Rectangle())
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 6
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.purple, lineWidth: 1)
            )
            .padding(.leading, 5)
            .padding(.bottom, -25)
            .offset(y: -20)
    }
}
