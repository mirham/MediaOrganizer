//
//  MainView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 13.09.2024.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var dragOverSourceFolder = false
    @State private var dragOverDestinationFolder = false
    
    @State private var generatedCount = 0
    @State private var progress = 0.0
    
    @State private var generationInProgress = false
    
    private let timer = Timer.publish(
        every: Constants.progressBarUpdateInterval,
        on: .main,
        in: .common)
        .autoconnect()
    
    var body: some View {
        VStack {
            HStack {
                Image(nsImage: getFolderImage(folderType: .source))
                    .resizable()
                    .frame(width: 128, height: 128)
                    .gesture(TapGesture().onEnded {
                        selectFolder(folderType: .source)
                    })
                    .onDrop(
                        of: [Constants.ddFolder],
                        isTargeted: $dragOverSourceFolder,
                        perform: selectSourceFolderFromDroppedItem
                    )
                Image(systemName: "arrow.forward")
                Image(systemName: "gearshape.arrow.triangle.2.circlepath")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 128, height: 128)
                Image(systemName: "arrow.forward")
                Image(nsImage: getFolderImage(folderType: .destination))
                    .resizable()
                    .frame(width: 128, height: 128)
                    .gesture(TapGesture().onEnded {
                        selectFolder(folderType: .destination)
                    })
                    .onDrop(
                        of: [Constants.ddFolder],
                        isTargeted: $dragOverDestinationFolder,
                        perform: selectDestinationFolderFromDroppedItem
                    )
            }
            Text(appState.userData.sourceFolder)
                .frame(width: 500, height: 30)
            Text(appState.userData.destinationFolder)
                .frame(width: 500, height: 30)
            Spacer()
            HStack {
                Button(action: {}) {
                    Text(Constants.elGenerate)
                        .frame(height: 30)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .background(
                            RoundedRectangle(cornerRadius: 5, style: .continuous).fill(Color.blue)
                        )
                }
                .buttonStyle(.plain)
                .disabled(false)
                .isHidden(hidden: generationInProgress, remove: true)
                ProgressView("Generating \(generatedCount) of \(/*appState.userData.count*/100) images (\(progress, specifier: "%.1f")%)", value: progress, total:100)
                    .onReceive(timer) { _ in
                        self.updateProgress()
                    }
                    .padding(7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.blue, lineWidth: 2)
                    )
                    .isHidden(hidden: !generationInProgress, remove: true)
            }
            .padding()
            Spacer()
        }
    }
    
    // MARK: Private functions
    private func getFolderImage(folderType: FolderType) -> NSImage {
        var result = NSImage(resource: .foldericon)
        var isFolder: ObjCBool = true
        
        switch folderType {
            case .source:
                if (appState.userData.sourceFolder != String()
                    && FileManager.default.fileExists(atPath: appState.userData.sourceFolder, isDirectory: &isFolder)) {
                    result = NSWorkspace.shared.icon(forFile: appState.userData.sourceFolder)
                }
            case .destination:
                if (appState.userData.destinationFolder != String()
                    && FileManager.default.fileExists(atPath: appState.userData.destinationFolder, isDirectory: &isFolder)) {
                    result = NSWorkspace.shared.icon(forFile: appState.userData.destinationFolder)
                }
        }
        
        return result
    }
    
    private func selectFolder(folderType: FolderType) {
        let folderChooserPoint = CGPoint(x: 0, y: 0)
        let folderChooserSize = CGSize(width: 500, height: 600)
        let folderChooserRectangle = CGRect(origin: folderChooserPoint, size: folderChooserSize)
        let folderPicker = NSOpenPanel(contentRect: folderChooserRectangle, styleMask: .utilityWindow, backing: .buffered, defer: true)
        
        folderPicker.canChooseDirectories = true
        folderPicker.canChooseFiles = false
        folderPicker.allowsMultipleSelection = false
        
        folderPicker.begin { response in
            if response == .OK {
                let pickedFolder = folderPicker.urls.first
                let path = pickedFolder?.path(percentEncoded: false).utf8.description ?? String()
                
                switch folderType {
                    case .source:
                        appState.userData.sourceFolder = path
                    case .destination:
                        appState.userData.destinationFolder = path
                }
            }
        }
    }
    
    private func selectSourceFolderFromDroppedItem(providers: [NSItemProvider]) -> Bool {
        return selectFolderFromDroppedItem(providers: providers, folderType: .source)
    }
    
    private func selectDestinationFolderFromDroppedItem(providers: [NSItemProvider]) -> Bool {
        return selectFolderFromDroppedItem(providers: providers, folderType: .destination)
    }
    
    private func selectFolderFromDroppedItem(providers: [NSItemProvider], folderType: FolderType) -> Bool {
        if let provider = providers.first {
            provider.loadDataRepresentation(
                forTypeIdentifier: Constants.ddFolder) { data, _ in
                    loadFolderPathFromDroppedItem(from: data, folderType: folderType)
                }
        }
        return true
    }
    
    private func loadFolderPathFromDroppedItem(from data: Data?, folderType: FolderType) {
        guard
            let data = data,
            let filePath = String(data: data, encoding: .ascii),
            let url = URL(string: filePath) else { return }
        
        var resultStorage: ObjCBool = true
        
        guard FileManager.default.fileExists(atPath: url.path(percentEncoded: false), isDirectory: &resultStorage)
        else { return }
        
        switch folderType {
            case .source:
                appState.userData.sourceFolder = url.path(percentEncoded: false)
            case .destination:
                appState.userData.destinationFolder = url.path(percentEncoded: false)
        }
    }
    
    private func updateProgress() {
        progress = (Double(generatedCount) / Double(/*appState.userData.count*/100)) * Constants.maxPercentage
        
        if(progress == Constants.maxPercentage) {
            generationInProgress = false
        }
    }
    
    private func resetProgress() {
        progress = Constants.minPercentage
        generatedCount = 0
    }
}

#Preview {
    MainView().environmentObject(AppState())
}
