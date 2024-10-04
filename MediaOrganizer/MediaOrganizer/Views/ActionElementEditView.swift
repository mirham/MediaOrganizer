//
//  ActionElementEditView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 02.10.2024.
//

import SwiftUI

struct ActionElementEditView: View {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.controlActiveState) private var controlActiveState
    
    @State private var showEditor: Bool = false
    @State private var selectedTypeId: Int?
    @State private var customText: String = String()
    @State private var customDate: Date = Date.distantPast
    
    private var elementInfo: ElementInfo
    private var elementOptions: ElementOptions
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    init(elementInfo: ElementInfo) {
        self.elementInfo = elementInfo
        self.elementOptions = ElementHelper.getElementOptionsByTypeId(typeId: elementInfo.elementTypeId)
        self.selectedTypeId = elementInfo.selectedTypeId ?? DateFormatType.dateEu.id
        self.customText = elementInfo.customText ?? String()
        self.customDate = elementInfo.customDate ?? Date.distantPast
    }
    
    var body: some View {
        HStack {
            Text(getEffectiveDispalyText())
                .contentShape(Rectangle())
                .padding(5)
            Button(String(), systemImage: Constants.iconEdit) {
                showEditor = true
            }
            .withEditButtonStyle(activeState: controlActiveState)
            .padding(.leading, -5)
            .isHidden(hidden: !(elementOptions.editable || elementOptions.hasFormula), remove: true)
            
        }
        .background(
            RoundedRectangle(cornerRadius: 5, style: .continuous).fill(elementOptions.background)
        )
        .isHidden(hidden: showEditor, remove: true)
        renderEditor()
            .padding(3)
            .background(
                RoundedRectangle(cornerRadius: 5, style: .continuous).fill(.blue)
            )
            .isHidden(hidden: !showEditor, remove: true)
    }
    
    // MARK: Private functions
    
    private func getEffectiveDispalyText() -> String {
        let result = customText != String()
            ? customText
            : customDate != Date.distantPast
                ? customDate.formatted(date: .numeric, time: .standard)
                : elementInfo.displayText
        
        return result
    }
    
    @ViewBuilder
    private func renderEditor() -> some View {
        switch elementInfo.settingType {
            case .date:
                renderDateFormatSelection()
            case .text:
                renderTextInput()
            default:
                EmptyView()
        }
    }
    
    @ViewBuilder
    private func renderDateFormatSelection() -> some View {
        HStack {
            Text(elementInfo.displayText)
                .padding(.trailing, -10)
                .isHidden(hidden: elementOptions.editable, remove: true)
            DatePicker(String(),
                       selection: $customDate,
                       displayedComponents: [.date, .hourAndMinute])
            .datePickerStyle(.compact)
                .isHidden(hidden: !elementOptions.editable, remove: true)
                .onAppear(perform: {
                    if (customDate == Date.distantPast) {
                        customDate = Date()
                    }
                })
            Picker(String(), selection: Binding(
                get: { selectedTypeId ?? DateFormatType.dateEu.id },
                set: {
                    selectedTypeId = $0
                }
            )) {
                ForEach(DateFormatType.allCases, id: \.id) { item in
                    HStack {
                        Text(item.description) + Text(Constants.space) +
                        (Text(item.example)
                            .font(.subheadline)
                            .foregroundStyle(.gray))
                    }
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: 20)
            Button(String(), systemImage: Constants.iconCheck) {
                elementInfo.selectedTypeId = selectedTypeId
                showEditor = false
            }
            .withRemoveButtonStyle(activeState: controlActiveState)
        }
        .isHidden(hidden: !showEditor, remove: true)
    }
    
    private func renderTextInput() -> some View {
        HStack {
            TextField(Constants.hintCustomText, text: $customText)
                .onChange(of: customText) {
                    customText = String(customText.prefix(Constants.customTextLimit))
                }
            .frame(maxWidth: 100)
            Button(String(), systemImage: Constants.iconCheck) {
                elementInfo.customText = customText
                showEditor = false
            }
            .withRemoveButtonStyle(activeState: controlActiveState)
        }
        .isHidden(hidden: !showEditor, remove: true)
    }
}

private extension Button {
    func withActionElementButtonStyle(activeState: ControlActiveState) -> some View {
        self.buttonStyle(.plain)
            .focusEffectDisabled()
            .font(.system(size: 16))
            .opacity(getViewOpacity(state: activeState))
    }
    
    func withEditButtonStyle(activeState: ControlActiveState) -> some View {
        self.withActionElementButtonStyle(activeState: activeState)
            .foregroundStyle(.blue)
    }
    
    func withRemoveButtonStyle(activeState: ControlActiveState) -> some View {
        self.withActionElementButtonStyle(activeState: activeState)
            .foregroundStyle(.green)
    }
}
