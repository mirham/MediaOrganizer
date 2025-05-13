//
//  ButtonExtensions.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 07.10.2024.
//


import SwiftUI

extension Button {
    func withSmallPlainButtonStyle(activeState: ControlActiveState) -> some View {
        self.buttonStyle(.plain)
            .focusEffectDisabled()
            .font(.system(size: 16))
            .opacity(getViewOpacity(state: activeState))
    }
    
    func withSmallAddButtonStyle(activeState: ControlActiveState) -> some View {
        self.withSmallPlainButtonStyle(activeState: activeState)
            .foregroundStyle(.green)
    }
    
    func withSmallSaveButtonStyle(activeState: ControlActiveState) -> some View {
        self.withSmallAddButtonStyle(activeState: activeState)
    }
    
    func withSmallEditButtonStyle(activeState: ControlActiveState) -> some View {
        self.withSmallPlainButtonStyle(activeState: activeState)
            .foregroundStyle(.blue)
    }
    
    func withSmallRemoveButtonStyle(activeState: ControlActiveState) -> some View {
        self.withSmallPlainButtonStyle(activeState: activeState)
            .foregroundStyle(.red)
    }
}
