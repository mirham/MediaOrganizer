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
    private var appState: AppState?
    private var allowWindowClose: () -> Bool
    
    override init() {
        self.allowWindowClose = { true }
        super.init()
    }
    
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
    
    func setAppState(_ appState: AppState) {
        self.appState = appState
        self.allowWindowClose = { appState.current.allowWindowClose() }
        
        appState.$current
            .sink { [weak self] current in
                self?.allowWindowClose = { current.allowWindowClose() }
            }
            .store(in: &cancellables)
    }
    
    // MARK: Intenal functions
    
    internal func windowShouldClose(_ sender: NSWindow) -> Bool {
        let allowClose = allowWindowClose()
        
        if !allowClose {
            let alert = NSAlert()
            alert.messageText = Constants.dialogHeaderCompleteAction
            alert.informativeText = Constants.dialogBodyCompleteAction
            alert.addButton(withTitle: Constants.dialogButtonOk)
            alert.beginSheetModal(for: sender) { response in }
            
            return false
        }
        
        return allowClose
    }
}
