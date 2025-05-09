//
//  ConditionElementEditView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 07.05.2025.
//

import SwiftUI

struct ConditionElementEditView: ElementContainerView {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.controlActiveState) private var controlActiveState
    
    @State private var showEditor: Bool = false
    @State private var selectedFormatTypeId: Int?
    @State private var selectedOperatorTypeId: Int?
    @State private var conditionValueString: String
    @State private var conditionValueInt: Int
    @State private var conditionValueDate: Date
    @State private var conditionValueDouble: Double
    
    private let element: ConditionElement
    
    private var elementOptions: ElementOptions {
        get {
            return getElementOptionsByTypeId(typeId: element.elementTypeId)
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    init(element: ConditionElement) {
        self.element = element
        self.selectedFormatTypeId = element.selectedFormatTypeId
        self.selectedOperatorTypeId = element.selectedOperatorTypeId
        self.conditionValueString = element.value.stringValue ?? String()
        self.conditionValueInt = element.value.intValue ?? 0
        self.conditionValueDate = element.value.dateValue ?? Date.distantPast
        self.conditionValueDouble = element.value.doubleValue ?? 0.0
    }
    
    var body: some View {
        HStack {
            HStack {
                let operatorDescription = getOperatorDescription(
                    conditionValueType: elementOptions.conditionValueType,
                    selectedOperatorTypeId: element.selectedOperatorTypeId)
                
                Text(element.displayText
                     + getConditionFormatDescription(
                        conditionValueType: elementOptions.conditionValueType,
                        selectedFormatTypeId: self.selectedFormatTypeId))
                Text(operatorDescription)
                    .foregroundStyle(.gray)
                    .font(.system(size: 12))
                    .isHidden(hidden: operatorDescription == String(), remove: true)
                Text(element.value.toString())
                    .isHidden(hidden: element.value.toString() == String(), remove: true)
            }
            .contentShape(Rectangle())
            .padding(5)
            Button(String(), systemImage: Constants.iconEdit) {
                showEditor = true
            }
            .withEditButtonStyle(activeState: controlActiveState)
            .padding(.leading, -5)
            .isHidden(
                hidden: !elementOptions.editableInCondition,
                remove: true)
            
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
            .onDisappear(perform: saveCondition)
    }
    
    // MARK: Private functions
    
    private func saveCondition() {
        element.selectedFormatTypeId = selectedFormatTypeId
        element.selectedOperatorTypeId = selectedOperatorTypeId
        
        let valuesMap: [ConditionValueType: ConditionValue] = [
            .string: .string(conditionValueString),
            .int: .int(conditionValueInt),
            .double: .double(conditionValueDouble),
            .date: .date(conditionValueDate)
        ]
        
        let dateFormatsMap: [ConditionValueType: ConditionValue] = [
            .date: .date(conditionValueDate),
            .int: .int(conditionValueInt)
        ]
        
        guard let conditionType = elementOptions.conditionValueType else {
            return
        }
        
        if conditionType == .date, let selectedFormatTypeId = selectedFormatTypeId,
           let dateFormat = DateFormatType(rawValue: selectedFormatTypeId) {
            element.value = dateFormatsMap[dateFormat.getConditionValueType(), default: .date(conditionValueDate)]
        } else {
            element.value = valuesMap[conditionType, default: .date(conditionValueDate)]
        }
        
        appState.objectWillChange.send()
    }
    
    @ViewBuilder
    private func renderEditor() -> some View {
        switch elementOptions.conditionValueType {
            case .string:
                renderStringExpression()
            case .int:
                renderIntExpression()
            case .double:
                renderDoubleExpression()
            case .date:
                renderDateExpression()
            default:
                EmptyView()
        }
    }
    
    @ViewBuilder
    private func renderStringOperatorPicker() -> some View {
        Picker(String(), selection: Binding(
            get: { selectedOperatorTypeId ?? StringOperatorType.equals.id },
            set: {
                selectedOperatorTypeId = $0
            }
        )) {
            ForEach(StringOperatorType.allCases, id: \.id) { item in
                HStack {
                    Text(item.description)
                }
            }
        }
        .pickerStyle(.menu)
        .frame(maxWidth: 120)
    }
    
    @ViewBuilder
    private func renderNumberAndDateOperatorPicker() -> some View {
        Picker(String(), selection: Binding(
            get: { selectedOperatorTypeId ?? NumberAndDateOperatorType.equals.id },
            set: {
                selectedOperatorTypeId = $0
            }
        )) {
            ForEach(NumberAndDateOperatorType.allCases, id: \.id) { item in
                HStack {
                    Text(item.description)
                }
            }
        }
        .pickerStyle(.menu)
        .frame(maxWidth: 55)
    }
    
    @ViewBuilder
    private func renderIntInput() -> some View {
        TextField(Constants.hintCustomText, value:$conditionValueInt, formatter: NumberFormatter())
    }
    
    @ViewBuilder
    private func renderDatePicker() -> some View {
        DatePickerWithSecondsPopover(date: $conditionValueDate)
            .frame(maxWidth: 185)
        .onAppear(perform: {
            if (conditionValueDate == Date.distantPast) {
                conditionValueDate = Date.now
            }
        })
    }
    
    @ViewBuilder
    private func renderStringExpression() -> some View {
        HStack {
            Text(element.displayText)
            renderStringOperatorPicker()
            TextField(Constants.hintCustomText, text: $conditionValueString)
                .onChange(of: conditionValueString) {
                    conditionValueString = String(conditionValueString.prefix(Constants.customTextLimit))
                }
                .frame(maxWidth: 100)
            Button(String(), systemImage: Constants.iconCheck) {
                showEditor = false
            }
            .withRemoveButtonStyle(activeState: controlActiveState)
        }
        .isHidden(hidden: !showEditor, remove: true)
    }
    
    @ViewBuilder
    private func renderIntExpression() -> some View {
        HStack {
            Text(element.displayText)
            renderNumberAndDateOperatorPicker()
            renderIntInput()
                .onChange(of: conditionValueInt) {
                    // TODO RUSS: Validation here
                }
                .frame(maxWidth: 70)
            Button(String(), systemImage: Constants.iconCheck) {
                showEditor = false
            }
            .withRemoveButtonStyle(activeState: controlActiveState)
        }
        .isHidden(hidden: !showEditor, remove: true)
    }
    
    @ViewBuilder
    private func renderDoubleExpression() -> some View {
        HStack {
            let valueBinding = Binding(
                get: { self.conditionValueDouble },
                set: {
                    self.conditionValueDouble = Double(String(format:"%.4f", $0)) ?? 0.0
                })
            
            Text(element.displayText)
            renderNumberAndDateOperatorPicker()
            TextField(Constants.hintCustomText, value:valueBinding, formatter: NumberFormatters.fourFractionDigits)
                .onChange(of: conditionValueDouble) {
                    // TODO RUSS: Validation here
                }
                .frame(maxWidth: 100)
            Button(String(), systemImage: Constants.iconCheck) {
                showEditor = false
            }
            .withRemoveButtonStyle(activeState: controlActiveState)
        }
        .isHidden(hidden: !showEditor, remove: true)
    }
    
    private func renderDateExpression() -> some View {
        HStack {
            Text(element.displayText
                 + getConditionFormatDescription(
                    conditionValueType: elementOptions.conditionValueType,
                    selectedFormatTypeId: selectedFormatTypeId))
                .padding(.trailing, -10)
            Picker(String(), selection: Binding(
                get: { selectedFormatTypeId ?? DateFormatType.asIs.id },
                set: {
                    selectedFormatTypeId = $0
                }
            )) {
                ForEach(DateFormatType.selectForCondition(), id: \.id) { item in
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
            renderNumberAndDateOperatorPicker()
            renderInputWithSelectedType()
            Button(String(), systemImage: Constants.iconCheck) {
                element.selectedFormatTypeId = selectedFormatTypeId
                showEditor = false
            }
            .withRemoveButtonStyle(activeState: controlActiveState)
        }
        .isHidden(hidden: !showEditor, remove: true)
    }
    
    @ViewBuilder
    private func renderInputWithSelectedType() -> some View {
        if selectedFormatTypeId != nil {
            let dateFormat = DateFormatType(rawValue: selectedFormatTypeId!)
            
            if dateFormat != nil {
                if(dateFormat!.getConditionValueType() == .date) {
                    renderDatePicker()
                }
                
                if(dateFormat!.getConditionValueType() == .int) {
                    renderIntInput()
                        .frame(maxWidth: 50)
                }
            }
        }
    }
}

private extension Button {
    func withConditionElementButtonStyle(activeState: ControlActiveState) -> some View {
        self.buttonStyle(.plain)
            .focusEffectDisabled()
            .font(.system(size: 16))
            .opacity(getViewOpacity(state: activeState))
    }
    
    func withEditButtonStyle(activeState: ControlActiveState) -> some View {
        self.withConditionElementButtonStyle(activeState: activeState)
            .foregroundStyle(.blue)
    }
    
    func withRemoveButtonStyle(activeState: ControlActiveState) -> some View {
        self.withConditionElementButtonStyle(activeState: activeState)
            .foregroundStyle(.green)
    }
}
