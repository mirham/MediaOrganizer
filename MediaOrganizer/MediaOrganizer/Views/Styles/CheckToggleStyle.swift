//
//  CheckToggleStyle.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 16.09.2024.
//

import SwiftUI

struct CheckToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Label {
                configuration.label
            } icon: {
                Image(systemName: configuration.isOn ? Constants.iconCheckmark : Constants.iconCircle)
                    .foregroundStyle(configuration.isOn ? Color.primary : .secondary)
                    .accessibility(label: Text(
                        configuration.isOn ? Constants.elChecked : Constants.elUnchecked))
                    .imageScale(.large)
            }
        }
        .buttonStyle(.plain)
        .focusEffectDisabled()
    }
}
