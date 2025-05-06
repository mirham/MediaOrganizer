//
//  Container.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//

import Factory

// MARK: DI registrations

extension Container {
    var jobService: Factory<JobServiceType> {
        Factory(self) { JobService() }
    }
    
    var ruleService: Factory<RuleServiceType> {
        Factory(self) { RuleService() }
    }
    
    var actionService: Factory<ActionServiceType> {
        Factory(self) { ActionService() }
    }
    
    var metadataService: Factory<MetadataServiceType> {
        Factory(self) { MetadataService() }
    }
    
    var fileService: Factory<FileServiceType> {
        Factory(self) { FileService() }
    }
}

