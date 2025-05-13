//
//  DatePickerWithSecondsPopover.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 09.05.2025.
//

import SwiftUI
import AppKit

struct DatePickerWithSecondsPopover: NSViewRepresentable {
    @Binding var date: Date
    
    func makeNSView(context: Context) -> NSView {
        let textField = NSDatePicker()
        textField.datePickerStyle = .textField
        textField.datePickerElements = [.yearMonthDay, .hourMinuteSecond]
        textField.dateValue = date
        textField.isBordered = true
        textField.target = context.coordinator
        textField.action = #selector(Coordinator.showPopover(_:))
        
        let tapGesture = NSClickGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.showPopover(_:))
        )
        textField.addGestureRecognizer(tapGesture)
        
        context.coordinator.textField = textField
        return textField
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        if let textField = nsView as? NSDatePicker {
            textField.dateValue = date
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, NSPopoverDelegate {
        var parent: DatePickerWithSecondsPopover
        weak var textField: NSDatePicker?
        var popover: NSPopover?
        
        init(parent: DatePickerWithSecondsPopover) {
            self.parent = parent
            super.init()
        }
        
        @objc func showPopover(_ sender: Any?) {
            guard let textField = textField, popover?.isShown != true else {
                return
            }
            
            let popover = NSPopover()
            self.popover = popover
            popover.delegate = self
            popover.behavior = .transient
            
            let datePicker = NSDatePicker()
            datePicker.datePickerStyle = .clockAndCalendar
            datePicker.datePickerElements = [.yearMonthDay, .hourMinuteSecond]
            datePicker.dateValue = parent.date
            datePicker.target = self
            datePicker.action = #selector(updateDate(_:))
            
            let contentViewController = NSViewController()
            contentViewController.view = datePicker
            popover.contentViewController = contentViewController
            
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                datePicker.leadingAnchor.constraint(equalTo: contentViewController.view.leadingAnchor),
                datePicker.trailingAnchor.constraint(equalTo: contentViewController.view.trailingAnchor),
                datePicker.topAnchor.constraint(equalTo: contentViewController.view.topAnchor),
                datePicker.bottomAnchor.constraint(equalTo: contentViewController.view.bottomAnchor)
            ])
            
            let pickerSize = datePicker.intrinsicContentSize
            popover.contentSize = NSSize(width: max(pickerSize.width, 290), height: max(pickerSize.height, 150))
            contentViewController.view.frame = NSRect(origin: .zero, size: popover.contentSize)
            
            popover.contentViewController = contentViewController
            
            popover.show(relativeTo: textField.bounds, of: textField, preferredEdge: .minY)
        }
        
        @objc func updateDate(_ sender: NSDatePicker) {
            parent.date = sender.dateValue
            textField?.dateValue = sender.dateValue
        }
        
        func popoverDidClose(_ notification: Notification) {
            popover = nil
        }
    }
}
