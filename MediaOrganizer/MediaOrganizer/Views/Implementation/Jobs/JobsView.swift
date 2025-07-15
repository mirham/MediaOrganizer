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
    
    var body: some View {
        ScrollView(.vertical) {
            ForEach(appState.userData.jobs, id: \.id) { job in
                HStack {
                    HStack {
                        Toggle(String(), isOn: Binding(
                            get: { job.checked },
                            set: {
                                jobService.toggleJob(jobId: job.id, checked: $0)
                            }))
                        .toggleStyle(CheckToggleStyle())
                        Image(nsImage: getFolderIcon(folder: job.sourceFolder))
                            .resizable()
                            .frame(width: 42, height: 42)
                        Image(nsImage: getFolderIcon(folder: job.outputFolder))
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
                        Text(String(format: Constants.maskSource, job.sourceFolder))
                            .foregroundStyle(jobService.isCurrentJob(jobId: job.id) ? .white : .gray)
                            .font(.system(size: 11))
                        Text(String(format: Constants.maskOutput, job.outputFolder))
                            .foregroundStyle(jobService.isCurrentJob(jobId: job.id) ? .white : .gray)
                            .font(.system(size: 11))
                        JobProgressView(job: job)
                    }
                    HStack {
                        JobRunView(job: job)
                        JobAbortView(job: job)
                    }
                }
                .contentShape(Rectangle())
                .background(jobService.isCurrentJob(jobId: job.id) ? Color(hex: Constants.colorHexSelection) : .clear)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .gesture(TapGesture(count: 2).onEnded {
                    handleJobItemDoubleClick(job: job)
                })
                .simultaneousGesture(TapGesture().onEnded {
                    handleJobItemClick(job: job)
                })
                Divider()
            }
        }
        .safeAreaInset(edge: .bottom, content: {
            VStack {
                Divider()
                HStack {
                    JobsToolbarView()
                }
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity)
            }
            .background(Color(hex: Constants.colorHexPanelDark))
        })
        .onTapGesture {
            hanldeJobScrollViewClick()
        }
        .toolbar(content: {
            JobsHeaderToolbarView()
                .padding(.leading)
        })
        .onAppear() {
            appState.views.addShownWindow(windowId: Constants.windowIdMain)
        }
        .onDisappear() {
            appState.views.removeShownWindow(windowId: Constants.windowIdMain)
        }
    }
    
    // MARK: Private functions
    
    private func hanldeJobScrollViewClick () {
        guard appState.views.isWindowShown(windowId: Constants.windowIdMain)
        else { return }
        
        jobService.resetCurrentJob()
    }
    
    private func handleJobItemClick (job : Job) {
        guard appState.views.isWindowShown(windowId: Constants.windowIdMain)
        else { return }
        
        appState.current.job = job
    }
    
    private func handleJobItemDoubleClick (job : Job) {
        appState.current.job = job
        showEditJobWindow()
    }
    
    private func showEditJobWindow() {
        if !appState.views.isWindowShown(windowId: Constants.windowIdJobSettings) {
            openWindow(id: Constants.windowIdJobSettings)
        }
        
        ViewHelper.activateView(viewId: Constants.windowIdJobSettings)
    }
}

#Preview {
    JobsView().environmentObject(AppState())
}
