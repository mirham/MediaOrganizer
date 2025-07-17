//
//  JobLogView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 15.07.2025.
//

import SwiftUI
import Factory

struct JobLogView: View {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.controlActiveState) var controlActiveState
    
    @StateObject private var viewModel: LogViewModel
    
    @State private var selectedEntryId: UUID? = nil
    @State private var selectedEntryMessage: String? = nil
    
    var log: JobLogType
    
    init(jobId: UUID) {
        self.log = JobLog(jobId: jobId)
        let logUrl =  log.getLogFileUrl()
        self._viewModel = StateObject(wrappedValue: LogViewModel(fileURL: logUrl))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                ScrollViewReader { scrollProxy in
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(Array(viewModel.logEntries.enumerated()), id: \.element.id) { index, entry in
                            VStack(alignment: .leading) {
                                HStack() {
                                    Circle()
                                        .fill(entry.level == .info ? .green : .red)
                                        .frame(width: 10, height: 10)
                                    Text(entry.message)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                        .allowsHitTesting(false)
                                    Spacer()
                                }
                                .id(entry.id)
                                .padding(.horizontal, 8)
                            }
                            .frame(height: 25)
                            .frame(maxWidth: .infinity)
                            .background(
                                selectedEntryId == entry.id
                                ? Color.blue.opacity(0.3)
                                : (index % 2 == 0 ? Color.gray.opacity(0.08) : Color.clear)
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedEntryMessage = entry.message
                                selectedEntryId = entry.id
                            }
                        }
                    }
                    .onChange(of: viewModel.logEntries, { _, newEntries in
                        if let lastEntry = newEntries.last {
                            scrollProxy.scrollTo(lastEntry.id, anchor: .bottom)
                        }
                    })
                    .textSelection(.enabled)
                }
            }
            Divider()
            Text(selectedEntryMessage ?? String())
                .frame(maxWidth: .infinity, minHeight: 100, alignment: .topLeading)
                .padding(5)
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
}

#Preview {
    JobLogView(jobId: UUID()).environmentObject(AppState())
}
