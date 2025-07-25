//
//  ActionElementEditView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 02.10.2024.
//

import SwiftUI
import Factory

struct ActionElementEditView: ElementContainerView {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.controlActiveState) private var controlActiveState
    @Environment(\.colorScheme) private var colorScheme
    
    @Injected(\.validationService) private var validationService
    
    @State private var showEditor: Bool = false
    @State private var selectedDateFormatTypeId: Int? {
        didSet { handleSelectedDateFormatTypeIdDidSet() }
    }
    @State private var customText: String {
        didSet { handleCustomTextDidSet() }
    }
    @State private var customDate: Date {
        didSet { handleCustomDateDidSet() }
    }
    @State private var hasError: Bool
    
    private let element: ActionElement
    
    private var elementOptions: ElementOptions { get {
        return getElementOptionsByTypeId(
            typeId: element.elementTypeId,
            colorScheme: colorScheme)
    }}
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    init(element: ActionElement) {
        self.element = element
        self.selectedDateFormatTypeId = element.selectedDateFormatType == nil
            ? nil
            : element.selectedDateFormatType!.id
        self.customText = element.customText ?? String()
        self.customDate = element.customDate ?? Date.distantPast
        self.hasError = false
    }
    
    var body: some View {
        HStack {
            Text(getEffectiveDispalyText() + getFormatDescription())
                .contentShape(Rectangle())
                .padding(5)
            Button(String(), systemImage: Constants.iconEdit, action: handleEditButtonClick)
            .withEditButtonStyle(activeState: controlActiveState)
            .padding(.leading, -5)
            .isHidden(
                hidden: !(elementOptions.editableInAction || elementOptions.hasFormula),
                remove: true)
            
        }
        .background(
            RoundedRectangle(cornerRadius: 5, style: .continuous).fill(elementOptions.background)
        )
        .onAppear(perform: handleOnAppear)
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
                : element.displayText
        
        return result
    }
    
    private func getFormatDescription() -> String {
        guard self.selectedDateFormatTypeId != nil && elementOptions.elementValueType == .date
        else { return String() }
        
        let dateFormatType = DateFormatType.init(rawValue: self.selectedDateFormatTypeId!)
        
        guard dateFormatType != nil else { return String() }
        
        let result = dateFormatType == .amPm
            ? " (\(dateFormatType!.description))"
            : " (\(dateFormatType!.description.firstLowercased))"
        
        return result
    }
    
    private func handleSelectedDateFormatTypeIdDidSet() {
        appState.current.actionElement?.selectedDateFormatType
        = selectedDateFormatTypeId == nil
            ? nil
            : DateFormatType(rawValue: selectedDateFormatTypeId!)
    }
    
    private func handleCustomTextDidSet() {
        appState.current.actionElement?.customText = customText
    }
    
    private func handleCustomDateDidSet() {
        appState.current.actionElement?.customDate = customDate
    }
    
    @ViewBuilder
    private func renderEditor() -> some View {
        switch element.settingType {
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
            Text(element.displayText + getFormatDescription())
                .padding(.trailing, -10)
                .isHidden(hidden: elementOptions.editableInAction, remove: true)
            DatePickerWithSecondsPopover(date: $customDate)
                .isHidden(hidden: !elementOptions.editableInAction, remove: true)
                .frame(maxWidth: 150)
                .onAppear(perform: {
                    if (customDate == Date.distantPast) {
                        customDate = Date()
                    }
                })
            Picker(String(), selection: Binding(
                get: { selectedDateFormatTypeId ?? DateFormatType.dateEu.id },
                set: {
                    selectedDateFormatTypeId = $0
                }
            )) {
                ForEach(DateFormatType.selectForAction(), id: \.id) { item in
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
            Button(String(),
                   systemImage: Constants.iconCheck,
                   action: handleDateInputSaveClick)
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
            Button(String(),
                systemImage: Constants.iconCheck,
                action: handleTextInputSaveClick)
            .withRemoveButtonStyle(activeState: controlActiveState)
        }
        .isHidden(hidden: !showEditor, remove: true)
    }
    
    private func handleOnAppear() {
        guard let prevAction = appState.current.actionElement else {
            return
        }
        
        if element.id == prevAction.id {
            prevAction.copyValues(other: element)
            enterEditMode()
        }
    }
    
    private func handleEditButtonClick() {
        guard !appState.current.isActionElementInEditMode
        else {
            appState.current.validationMessage = Constants.vmFinishEditing
            return
        }
        
        enterEditMode()
    }
    
    private func handleDateInputSaveClick() {
        element.selectedDateFormatType = selectedDateFormatTypeId != nil
            ? DateFormatType(rawValue: selectedDateFormatTypeId!)
            : nil
        
        if customDate != Date.distantPast {
            let validationResult = validationService.isValidDate(input: customDate)
            handleValidationResult(validationResult: validationResult)
            
            guard !hasError else { return }
            
            element.customDate = customDate
        }
        else {
            handleValidationResult(validationResult: ValidationResult<Date>())
        }
    }
    
    private func handleTextInputSaveClick() {
        let validationResult = validationService.isValidString(input: customText, isArray: false)
        handleValidationResult(validationResult: validationResult)
        
        guard !hasError else { return }
        
        element.customText = customText
    }
    
    private func handleValidationResult<T>(validationResult: ValidationResult<T>) {
        hasError = !validationResult.isValid
        appState.current.validationMessage = validationResult.message
        exitEditMode(hasError: hasError)
    }
    
    private func enterEditMode() {
        appState.current.actionElement = self.element
        showEditor = true
        appState.current.isActionElementInEditMode = true
    }
    
    private func exitEditMode(hasError: Bool) {
        showEditor = hasError
        appState.current.isActionElementInEditMode = hasError
        appState.current.actionElement = hasError ? self.element : nil
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
