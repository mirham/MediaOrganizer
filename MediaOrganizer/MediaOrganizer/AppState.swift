//
//  AppState.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 13.09.2024.
//

import Foundation

class AppState : ObservableObject {
    @Published var userData = UserData()
    
    static let shared = AppState()
}

extension AppState {
    struct UserData : Settable, Equatable {
        var sourceFolder: String = String() {
            didSet { writeSetting(newValue: sourceFolder, key: Constants.settingsKeySourceFolder) }
        }
        var destinationFolder: String = String() {
            didSet { writeSetting(newValue: destinationFolder, key: Constants.settingsKeyDestinationFolder) }
        }
        
        static func == (lhs: UserData, rhs: UserData) -> Bool {
            let result = lhs.sourceFolder == rhs.sourceFolder
            && lhs.destinationFolder == rhs.destinationFolder
            
            
            return result
        }
        
        init() {
            sourceFolder = readSetting(key: Constants.settingsKeySourceFolder) ?? String()
            destinationFolder = readSetting(key: Constants.settingsKeyDestinationFolder) ?? String()
        }
    }
}
