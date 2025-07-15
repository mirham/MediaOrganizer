//
//  JobLogView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 15.07.2025.
//

import SwiftUI
import Combine
import Factory

struct JobLogView: View {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.controlActiveState) var controlActiveState
    
    @StateObject private var viewModel: LogViewModel
    
    var log: JobLogType
    
    init(jobId: UUID) {
        self.log = JobLog(jobId: jobId)
        let logUrl =  log.getLogFileUrl()
        self._viewModel = StateObject(wrappedValue: LogViewModel(fileURL: logUrl))
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { scrollProxy in
                    LazyVStack(alignment: .leading, spacing: 2) {
                        ForEach(viewModel.logEntries) { entry in
                            HStack(spacing: 8) {
                                Text(String("\(entry.number) |"))
                                    .font(.system(.body))
                                    .foregroundColor(.gray)
                                    .frame(width: 60, alignment: .trailing)
                                Text(entry.message)
                                    .font(.system(.body))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .id(entry.id)
                            .padding(.horizontal, 8)
                        }
                    }
                    .onChange(of: viewModel.logEntries, { _, newEntries in
                        if let lastEntry = newEntries.last {
                            scrollProxy.scrollTo(lastEntry.id, anchor: .bottom)
                        }
                    })
                    .textSelection(.enabled)
                    .padding(.vertical, 8)
                }
            }
            HStack {
                Button(Constants.elClear, action: handleClearLogClick)
                    .asLogButton()
            }
            .padding(.bottom, 5)
        }
        .onAppear(perform: {
            appState.views.addShownWindow(windowId: Constants.windowIdLog)
            ViewHelper.activateView(viewId: Constants.windowIdLog)
        })
        .onDisappear(perform: {
            appState.views.removeShownWindow(windowId: Constants.windowIdLog)
        })
        .opacity(getViewOpacity(state: controlActiveState))
    }
    
    // MARK: Private functions
    
    private func handleClearLogClick() {
        log.clearLogFile()
    }
}

class LogViewModel: NSObject, ObservableObject, NSFilePresenter {
    @Published var logEntries: [LogEntry] = []
    
    var presentedItemURL: URL?
    var presentedItemOperationQueue: OperationQueue = .main
    
    private var cancellables = Set<AnyCancellable>()
    private let fileChangeSubject = PassthroughSubject<Void, Never>()
    
    init(fileURL: URL?) {
        self.presentedItemURL = fileURL
        super.init()
        loadLogContent()
        startFileMonitoring()
        
        fileChangeSubject
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.loadLogContent()
            }
            .store(in: &cancellables)
    }
    
    deinit {
        stopFileMonitoring()
    }
    
    private func loadLogContent() {
        guard let fileURL = presentedItemURL else {
            DispatchQueue.main.async { [weak self] in
                self?.logEntries = []
            }
            return
        }
        
        do {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            let lines = content.split(separator: Constants.newLine, omittingEmptySubsequences: true)
            let entries = lines.enumerated().map { index, line in
                LogEntry(number: index + 1, message: String(line))
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.logEntries = entries
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                
                self?.logEntries = [LogEntry(
                    number: 1,
                    message: String(format: Constants.errorReadingLogFile, error.localizedDescription))]
            }
        }
    }
    
    private func startFileMonitoring() {
        guard presentedItemURL != nil else {
            return
        }
        
        NSFileCoordinator.addFilePresenter(self)
    }
    
    private func stopFileMonitoring() {
        NSFileCoordinator.removeFilePresenter(self)
    }
    
    func presentedItemDidChange() {
        fileChangeSubject.send()
    }
}

private extension Button {
    func asLogButton() -> some View {
        self.focusEffectDisabled()
            .padding(5)
    }
}

#Preview {
    JobLogView(jobId: UUID()).environmentObject(AppState())
}
