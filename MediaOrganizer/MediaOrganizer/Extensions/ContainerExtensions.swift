//
//  Container.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//

import Factory

// MARK: DI registrations

extension Container {
    
    // MARK: Services registrations
    
    var jobService: Factory<JobServiceType> {
        Factory(self) { JobService() }
    }
    
    var ruleService: Factory<RuleServiceType> {
        Factory(self) { RuleService() }
    }
    
    var conditionService: Factory<ConditionServiceType> {
        Factory(self) { ConditionService() }
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
    
    var elementService: Factory<ElementServiceType> {
        Factory(self) { ElementService() }
    }
    
    // MARK: Element strategies registration
    
    static var elementStrategies: [KeyPath<Container, Factory<ElementStrategy>>] = [
        \.slashStrategy,
         \.customDateStrategy,
         \.customTextStrategy,
         \.fileNameStrategy,
         \.fileExtensionStrategy,
         \.fileDateCreatedStrategy,
         \.fileDateModifiedStrategy,
         \.metadataDateOriginalStrategy,
         \.metadataDateDigitilizedStrategy,
         \.metadataCameraModelStrategy,
         \.metadataPixelXDimentionStrategy,
         \.metadataPixelYDimentionStrategy,
         \.metadataLatitudeStrategy,
         \.metadataLongitudeStrategy
    ]
    
    func elementStrategies() -> [ElementStrategy] {
        Container.elementStrategies.map { self[keyPath: $0]() }
    }
    
    var elementStrategyFactory: Factory<ElementStrategyFactoryType> {
        Factory(self) { ElementStrategyFactory() }
    }
    
    // MARK: File action strategies registration
    
    static var fileActionStrategies: [KeyPath<Container, Factory<FileActionStrategy>>] = [
        \.copyToFolderStrategy,
        \.moveToFolderStrategy,
        \.renameStrategy,
        \.deleteStrategy,
        \.skipStrategy
    ]
    
    func fileActionStrategies() -> [FileActionStrategy] {
        Container.fileActionStrategies.map { self[keyPath: $0]() }
    }
    
    var fileActionStrategyFactory: Factory<FileActionStrategyFactoryType> {
        Factory(self) { FileActionStrategyFactory() }
    }
}

extension SharedContainer {
    
    // MARK: Element strategies registration
    
    var slashStrategy: Factory<ElementStrategy> {
        Factory(self) { SlashStrategy() }
    }
    
    var customDateStrategy: Factory<ElementStrategy> {
        Factory(self) { CustomDateStrategy() }
    }
    
    var customTextStrategy: Factory<ElementStrategy> {
        Factory(self) { CustomTextStrategy() }
    }
    
    var fileNameStrategy: Factory<ElementStrategy> {
        Factory(self) { MetadataStringStrategy(
            typeKey: MetadataType.fileName.rawValue,
            metadataKey: MetadataType.fileName) }
    }
    
    var fileExtensionStrategy: Factory<ElementStrategy> {
        Factory(self) { FileExtensionStrategy() }
    }
    
    var fileDateCreatedStrategy: Factory<ElementStrategy> {
        Factory(self) { MetadataDateStrategy(
            typeKey: MetadataType.fileDateCreated.rawValue,
            metadataKey: MetadataType.fileDateCreated) }
    }
    
    var fileDateModifiedStrategy: Factory<ElementStrategy> {
        Factory(self) { MetadataDateStrategy(
            typeKey: MetadataType.fileDateModified.rawValue,
            metadataKey: MetadataType.fileDateModified) }
    }
    
    var metadataDateOriginalStrategy: Factory<ElementStrategy> {
        Factory(self) { MetadataDateStrategy(
            typeKey: MetadataType.metadataDateOriginal.rawValue,
            metadataKey: MetadataType.metadataDateOriginal) }
    }
    
    var metadataDateDigitilizedStrategy: Factory<ElementStrategy> {
        Factory(self) { MetadataDateStrategy(
            typeKey: MetadataType.metadataDateDigitilized.rawValue,
            metadataKey: MetadataType.metadataDateDigitilized) }
    }
    
    var metadataCameraModelStrategy: Factory<ElementStrategy> {
        Factory(self) { MetadataStringStrategy(
            typeKey: MetadataType.metadataCameraModel.rawValue,
            metadataKey: MetadataType.metadataCameraModel) }
    }
    
    var metadataPixelXDimentionStrategy: Factory<ElementStrategy> {
        Factory(self) { MetadataStringStrategy(
            typeKey: MetadataType.metadataPixelXDimention.rawValue,
            metadataKey: MetadataType.metadataPixelXDimention) }
    }
    
    var metadataPixelYDimentionStrategy: Factory<ElementStrategy> {
        Factory(self) { MetadataStringStrategy(
            typeKey: MetadataType.metadataPixelYDimention.rawValue,
            metadataKey: MetadataType.metadataPixelYDimention) }
    }
    
    var metadataLatitudeStrategy: Factory<ElementStrategy> {
        Factory(self) { MetadataStringStrategy(
            typeKey: MetadataType.metadataLatitude.rawValue,
            metadataKey: MetadataType.metadataLatitude) }
    }
    
    var metadataLongitudeStrategy: Factory<ElementStrategy> {
        Factory(self) { MetadataStringStrategy(
            typeKey: MetadataType.metadataLongitude.rawValue,
            metadataKey: MetadataType.metadataLongitude) }
    }
    
    // MARK: Action strategies registration
    
    var copyToFolderStrategy: Factory<FileActionStrategy> {
        Factory(self) { CopyToFolderStrategy() }
    }
    
    var moveToFolderStrategy: Factory<FileActionStrategy> {
        Factory(self) { MoveToFolderStrategy() }
    }
    
    var renameStrategy: Factory<FileActionStrategy> {
        Factory(self) { RenameStrategy() }
    }
    
    var deleteStrategy: Factory<FileActionStrategy> {
        Factory(self) { DeleteStrategy() }
    }
    
    var skipStrategy: Factory<FileActionStrategy> {
        Factory(self) { SkipStrategy() }
    }
}
