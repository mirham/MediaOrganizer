//
//  JobGeneralSettingsEditView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 16.09.2024.
//

import SwiftUI

struct JobGeneralSettingsEditView: FolderContainerView {
    @EnvironmentObject var appState: AppState
    
    private let jobService = JobService.shared
    
    @State private var jobName = String()
    
    @State private var dragOverSourceFolder = false
    @State private var dragOverDestinationFolder = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("\(Constants.elJobName):")
                }
                VStack(alignment: .leading, spacing: 12) {
                    TextField(Constants.hintJobName, text: $jobName)
                        .frame(width: 150)
                        .onChange(of: jobName) {
                            guard appState.current.job != nil else { return }
                            appState.current.job!.name = jobName
                        }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(30)
            HStack(alignment: .center) {
                Image(nsImage: getFolderIcon(folder: appState.current.job?.sourceFolder ?? String()))
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
                Image(systemName: Constants.iconArrowForward)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(30)
                Image(nsImage: getFolderIcon(folder: appState.current.job?.outputFolder ?? String()))
                    .resizable()
                    .frame(width: 128, height: 128)
                    .gesture(TapGesture().onEnded {
                        selectFolder(folderType: .output)
                    })
                    .onDrop(
                        of: [Constants.ddFolder],
                        isTargeted: $dragOverDestinationFolder,
                        perform: selectOutputFolderFromDroppedItem
                    )
            }
            .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
                .frame(height: 30)
            VStack(alignment: .leading) {
                Text(String(format: Constants.maskSource, appState.current.job?.sourceFolder ?? String()))
                Text(String(format: Constants.maskOutput, appState.current.job?.outputFolder ?? String()))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            Spacer()
        }
        .onAppear() {
            jobName = appState.current.job?.name ?? Constants.defaultJobName
        }
    }
    
    // MARK: Private functions
    
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
                        appState.current.job?.sourceFolder = path
                    case .output:
                        appState.current.job?.outputFolder = path
                }
                
                self.appState.objectWillChange.send()
            }
        }
    }
    
    private func selectSourceFolderFromDroppedItem(providers: [NSItemProvider]) -> Bool {
        return selectFolderFromDroppedItem(providers: providers, folderType: .source)
    }
    
    private func selectOutputFolderFromDroppedItem(providers: [NSItemProvider]) -> Bool {
        return selectFolderFromDroppedItem(providers: providers, folderType: .output)
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
                appState.current.job?.sourceFolder = url.path(percentEncoded: false)
            case .output:
                appState.current.job?.outputFolder = url.path(percentEncoded: false)
        }
        
        self.appState.objectWillChange.send()
    }
}

#Preview {
    JobGeneralSettingsEditView().environmentObject(AppState())
}
