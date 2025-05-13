//
//  DatePickerWithSeconds.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 09.05.2025.
//

import SwiftUI
import AppKit

struct DatePickerWithSeconds: NSViewRepresentable {
    @Binding var date: Date
    
    func makeNSView(context: Context) -> NSDatePicker {
        let datePicker = NSDatePicker()
        datePicker.datePickerStyle = .clockAndCalendar
        datePicker.datePickerElements = [.yearMonthDay, .hourMinuteSecond]
        datePicker.dateValue = date
        datePicker.target = context.coordinator
        datePicker.action = #selector(Coordinator.dateChanged(_:))
        return datePicker
    }
    
    func updateNSView(_ nsView: NSDatePicker, context: Context) {
        nsView.dateValue = date
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: DatePickerWithSeconds
        
        init(_ parent: DatePickerWithSeconds) {
            self.parent = parent
        }
        
        @objc func dateChanged(_ sender: NSDatePicker) {
            parent.date = sender.dateValue
        }
    }
}
