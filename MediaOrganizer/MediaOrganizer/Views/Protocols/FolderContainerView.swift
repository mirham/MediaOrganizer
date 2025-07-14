//
//  FolderContainerView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 16.09.2024.
//

import SwiftUI

protocol FolderContainerView : View {}

extension FolderContainerView {
    func getFolderIcon(folder: String) -> NSImage {
        var result = NSImage(resource: .foldericon)
        var isFolder: ObjCBool = true
        
        let doesFolderExist = (folder != String() && folder != Constants.stubNotSelected)
            && FileManager.default.fileExists(atPath: folder, isDirectory: &isFolder)
        
        if doesFolderExist {
            result = NSWorkspace.shared.icon(forFile: folder)
        }
        
        return result
    }
}
