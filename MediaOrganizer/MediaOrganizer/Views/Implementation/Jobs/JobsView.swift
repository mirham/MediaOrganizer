//
//  JobsView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 13.09.2024.
//

import SwiftUI
import Factory

struct JobsView: FolderContainerView {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.openWindow) private var openWindow
    
    @Injected(\.jobService) private var jobService
    
    @State private var selectedJobId: UUID? = nil
    
    var body: some View {
        VStack {
            Text(Constants.elJobs)
                .asJobsCaption()
                .padding(.top, 5)
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(appState.userData.jobs.enumerated()), id: \.element.id) {index, job in
                        HStack {
                            HStack {
                                Toggle(String(), isOn: Binding(
                                    get: { job.checked },
                                    set: {
                                        jobService.toggleJob(jobId: job.id, checked: $0)
                                    }))
                                .toggleStyle(CheckToggleStyle())
                                Image(nsImage: getFolderIcon(folderPath: job.sourceFolder))
                                    .resizable()
                                    .frame(width: 42, height: 42)
                                Image(nsImage: getFolderIcon(folderPath: job.outputFolder))
                                    .resizable()
                                    .frame(width: 42, height: 42)
                                    .offset(x: -20, y: 35)
                                    .padding(.bottom, 45)
                            }
                            .padding(.leading, 10)
                            VStack (alignment: .leading) {
                                Text(job.name)
                                    .fontWeight(.bold)
                                    .padding(.top, 5)
                                    .padding(.bottom, 2)
                                    .font(.system(size: 14))
                                Text(getFolderPath(
                                    folderPath: job.sourceFolder,
                                    folderType: .source))
                                    .foregroundStyle(jobService.isCurrentJob(jobId: job.id) ? .white : .gray)
                                    .font(.system(size: 11))
                                Text(getFolderPath(
                                    folderPath: job.outputFolder,
                                    folderType: .output))
                                    .foregroundStyle(jobService.isCurrentJob(jobId: job.id) ? .white : .gray)
                                    .font(.system(size: 11))
                                JobProgressView(job: job)
                            }
                            HStack {
                                JobRunView(job: job)
                                JobAbortView(job: job)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(
                            selectedJobId == job.id && appState.current.job != nil
                            ? Color.blue.opacity(0.3)
                            : (index % 2 == 0 ? Color.gray.opacity(0.08) : Color.clear)
                        )
                        .contentShape(Rectangle())
                        .gesture(TapGesture(count: 2).onEnded {
                            handleJobItemDoubleClick(job: job)
                        })
                        .simultaneousGesture(TapGesture().onEnded {
                            handleJobItemClick(job: job)
                        })
                        Divider()
                    }
                }
            }
        }
        .disabled(shouldDisableActions())
        .onTapGesture {
            hanldeJobScrollViewClick()
        }
        .onChange(of: appState.views.shownWindows, setupCloseButton)
        .onChange(of: appState.current.job, {
            selectedJobId = appState.current.job?.id ?? nil
        })
        .onAppear() {
            appState.views.addShownWindow(windowId: Constants.windowIdMain)
        }
        .onDisappear() {
            handleCloseWindow()
        }
        .onReceive(NotificationCenter.default.publisher(
            for: NSApplication.willTerminateNotification),
            perform: { output in handleCloseApp() })
        .toolbar(content: {
            JobsHeaderToolbarView()
                .disabled(shouldDisableActions())
                .padding(.leading)
        })
        .safeAreaInset(edge: .bottom, content: {
            VStack {
                Divider()
                HStack {
                    JobsToolbarView()
                        .disabled(shouldDisableActions())
                }
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity)
            }
            .background(Color(hex: Constants.colorHexPanelDark))
        })
    }
    
    // MARK: Private functions
    
    private func setupCloseButton() {
        let isEnabled = !appState.views.isWindowShown(
            windowId: Constants.windowIdJobSettings)
        
        ViewHelper.setUpCloseViewButton(
            viewName: Constants.windowIdMain,
            enable: isEnabled)
    }
    
    private func shouldDisableActions() -> Bool {
        return appState.views.isWindowShown(windowId: Constants.windowIdJobSettings)
    }
    
    private func hanldeJobScrollViewClick () {
        guard appState.views.isWindowShown(windowId: Constants.windowIdMain)
                && !shouldDisableActions()
        else { return }
        
        jobService.resetCurrentJob()
    }
    
    private func handleJobItemClick (job : Job) {
        guard appState.views.isWindowShown(windowId: Constants.windowIdMain)
        else { return }
        
        guard !appState.views.isWindowShown(windowId: Constants.windowIdJobSettings)
        else { return }
        
        appState.current.job = job
    }
    
    private func handleJobItemDoubleClick (job : Job) {
        guard !appState.views.isWindowShown(windowId: Constants.windowIdJobSettings)
        else { return }
        
        appState.current.job = job
        showEditJobWindow()
    }
    
    private func showEditJobWindow() {
        if !appState.views.isWindowShown(windowId: Constants.windowIdJobSettings) {
            openWindow(id: Constants.windowIdJobSettings)
        }
        
        ViewHelper.activateView(viewId: Constants.windowIdJobSettings)
    }
    
    private func handleCloseWindow() {
        appState.views.removeShownWindow(windowId: Constants.windowIdMain)
    }
    
    private func handleCloseApp() {
        for jobId in appState.userData.jobs.map({$0.id}) {
            let jobLog = JobLog(jobId: jobId)
            jobLog.deleteLogFile()
        }
    }
}

private extension Text {
    func asJobsCaption() -> some View {
        self.textCase(.uppercase)
            .font(.system(size: 10))
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    JobsView().environmentObject(AppState())
}
