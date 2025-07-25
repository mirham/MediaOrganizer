//
//  FolderContainerView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 16.09.2024.
//

import SwiftUI

protocol FolderContainerView : ColorThemeSupportedView {}

extension FolderContainerView {
    func getFolderIcon(folderPath: String?) -> NSImage {
        var result = NSImage(resource: .foldericonsetup)
        
        guard let folderPath = folderPath,
              folderPath != Constants.stubNotSelected
        else { return result }
        
        var isFolder: ObjCBool = true
        let doesFolderExist = FileManager.default.fileExists(
            atPath: folderPath,
            isDirectory: &isFolder)
        
        result = doesFolderExist
            ? NSWorkspace.shared.icon(forFile: folderPath)
            : NSImage(resource: .warningicon)
        
        return result
    }
    
    func getFolderPath(folderPath: String?, folderType: FolderType) -> String {
        let mask = folderType == .source
            ? Constants.maskSource
            : Constants.maskOutput
        
        guard let folderPath = folderPath,
              folderPath != Constants.stubNotSelected
        else { return "\(String(format: mask, folderPath ?? String()))" }
        
        var isFolder: ObjCBool = true
        let doesFolderExist = FileManager.default.fileExists(
            atPath: folderPath,
            isDirectory: &isFolder)
        
        let result = doesFolderExist
            ? String(format: mask, folderPath)
            : "\(String(format: mask, folderPath)) (\(Constants.elIsNotAvailable))"
        
        return result
    }
}
