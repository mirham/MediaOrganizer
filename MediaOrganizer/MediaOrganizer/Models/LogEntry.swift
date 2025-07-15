//
//  LogEntry.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 15.07.2025.
//

import Foundation

struct LogEntry: Identifiable, Equatable {
    let id = UUID()
    let number: Int
    let message: String
}
