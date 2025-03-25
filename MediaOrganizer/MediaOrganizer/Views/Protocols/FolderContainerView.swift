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
        
        if ((folder != String() && folder != Constants.stubNotSelected)
            && FileManager.default.fileExists(atPath: folder, isDirectory: &isFolder)) {
            result = NSWorkspace.shared.icon(forFile: folder)
        }
        
        return result
    }
}
