//
//  AppDelegate.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 13.09.2024.
//

import SwiftUI
import AppKit
import Combine

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    private var cancellables = Set<AnyCancellable>()
    private var infoBoxWindowController: NSWindowController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        for window in NSApplication.shared.windows {
            window.delegate = self
        }
    }
    
    func showInfoWindow() {
        if infoBoxWindowController == nil {
            let styleMask: NSWindow.StyleMask = [.closable, .miniaturizable, .titled]
            let window = NSWindow()
            window.styleMask = styleMask
            window.title = Constants.elInfo
            window.contentView = NSHostingView(rootView: InfoView())
            window.center()
            infoBoxWindowController = NSWindowController(window: window)
        }
        
        infoBoxWindowController?.showWindow(infoBoxWindowController?.window)
    }
}
