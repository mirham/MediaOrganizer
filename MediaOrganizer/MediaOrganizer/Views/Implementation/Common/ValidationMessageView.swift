//
//  ValidationMessageView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 08.07.2025.
//

import SwiftUI

struct ValidationMessageView : View {
    @EnvironmentObject var appState: AppState
    
    private let text: String
    private let severity: ValidationSeverity
    private let offset: Double
    private let paddingBottom: Double
    private let hideFunc: () -> Bool
    
    init(text: String,
         severity: ValidationSeverity = .error,
         offset: Double = 0,
         paddingBottom: Double = 0,
         hideFunc: @escaping () -> Bool) {
        self.text = text
        self.severity = severity
        self.offset = offset
        self.paddingBottom = paddingBottom
        self.hideFunc = hideFunc
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: severity == .error
                      ? Constants.iconError
                      : Constants.iconWarning)
                Text(text)
            }
        }
        .asValidationMessage(
            color: severity == .error ? .red : .orange,
            offset: offset,
            paddingBottom: paddingBottom)
        .isHidden(hidden: hideFunc(), remove: true)
    }
}

private extension VStack {
    func asValidationMessage(color: Color, offset: Double, paddingBottom: Double) -> some View {
        self.frame(minWidth: 400, maxWidth: .infinity, minHeight: 20)
            .background(
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(color.opacity(0.6))
            )
            .contentShape(Rectangle())
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 6
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(color, lineWidth: 1)
            )
            .padding(.leading, 5)
            .padding(.bottom, paddingBottom)
            .offset(y: offset)
    }
}
