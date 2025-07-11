//
//  Constants.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 13.09.2024.
//

import Foundation

struct Constants {
    // MARK: Default values
    static let appName = "MirHam Media Organizer"
    static let step: Int = 1
    static let progressBarUpdateInterval: Double = 0.1
    static let threadChunk = 50
    static let minPercentage: Double = 0
    static let maxPercentage: Double = 100
    static let defaultJobName = "New job"
    static let dragAndDropTimeToleranceInSeconds: Int = 1
    static let customTextLimit = 100
    static let defaultToleranceInNanoseconds: UInt64 = 100_000_000
    static let maxFileNameLength = 255
    static let maxFolderPathLength = 1024
    
    // MARK: Symbols and strings
    static let space = "   "
    static let spaceShort = " "
    static let slash = "/"
    static let slashChar: Character = "/"
    static let dot = "."
    static let comma = ","
    static let nullChar = "\0"
    static let colon = ":"
    
    // MARK: Settings key names
    static let settingsKeyJobs = "jobs"
    
    // MARK: Window IDs
    static let windowIdJobSettings = "job-settings-view"
    static let windowIdInfo = "info-view"
    
    // MARK: Icons
    static let iconApp = "AppIcon"
    static let iconRun = "play.fill"
    static let iconArrowForward = "arrow.forward"
    static let iconAdd = "plus.circle.fill"
    static let iconRemove = "minus.circle.fill"
    static let iconSettings = "gearshape.2"
    static let iconCheckmark = "checkmark.circle.fill"
    static let iconCircle = "circle"
    static let iconArrowDown = "arrow.down.circle.fill"
    static let iconCheck = "checkmark.circle.fill"
    static let iconEdit = "pencil.circle.fill"
    static let iconFile = "doc.fill"
    static let iconStop = "stop.fill"
    static let iconCancel = "xmark.circle.fill"
    static let iconWarning = "exclamationmark.triangle"
    
    // MARK: Colors
    static let colorHexSelection = "#244EC9"
    static let colorHexPanelDark = "#313131"
    static let colorHexFileElement = "#681892"
    static let colorHexExifElement = "#093576"
    static let colorHexCustomElement = "#C49518"
    static let colorHexExpressionElement = "#39C43A"
    
    // MARK: Regexes
    static let regexLocationInIso6709 = "([+-][0-9.]+)([+-][0-9.]+)"
    static let regexEncodedLocationInIso6709 = "%+09.5f%+010.5f%+.0fCRSWGS_84/"
    static let regexSlash = /\//
    static let regexTwoSlashes = /\/\//
    
    // MARK: Condition elements supported types
    static let ceString = "string";
    static let ceInt = "int";
    static let ceDouble = "double";
    static let ceDate = "date";
    
    // MARK: Validation
    static let stringMinLength = 1
    static let stringMaxLength = 50
    static let yearMinValue = 1900
    static let yearMaхValue = 2100
    static let monthMinValue = 1
    static let monthMaхValue = 12
    static let dayMinValue = 1
    static let dayMaхValue = 31
    static let hourMinValue = 0
    static let hourMaхValue = 24
    static let minuteMinValue = hourMinValue
    static let minuteMaхValue = 59
    static let secondMinValue = hourMinValue
    static let secondMaхValue = minuteMaхValue
    static let resolutionMinValue = 1
    static let resolutionMaxValue = 16384
    static let latitudeMinValue: Double = -90.0
    static let latitudeMaxValue: Double = 90.0
    static let longitudeMinValue: Double = -180.0
    static let longitudeMaxValue: Double = 180.0
    static let defaultValidationDateFormat = "yyyy/MM/dd HH:mm:ss"
    static let dateMinValueString = "1900/01/01 00:00:00"
    static let dateMaxValueString = "2100/12/31 23:59:59"
    
    // MARK: Validation messages
    static let vmStringLengthIsIncorrect = "The string must contain no more than \(stringMinLength) characters and no less than \(stringMaxLength) characters.";
    static let vmYearIsIncorrect = "The year must be not before \(yearMinValue) and not after \(yearMaхValue).";
    static let vmMonthIsIncorrect = "The month must be between \(monthMinValue) and \(monthMaхValue).";
    static let vmDayIsIncorrect = "The day must be between \(dayMinValue) and \(dayMaхValue)."
    static let vmHourIsIncorrect = "Hours must be between \(hourMinValue) and \(hourMaхValue)."
    static let vmMinuteIsIncorrect = "Minutes must be between \(minuteMinValue) and \(minuteMaхValue).";
    static let vmSecondIsIncorrect = "Seconds must be between \(secondMinValue) and \(secondMaхValue).";
    static let vmDateIsIncorrect = "Date must be between '\(dateMinValueString)' and '\(dateMaxValueString)'.";
    static let vmResolutionIsIncorrect = "The resolution value must be between \(resolutionMinValue) and \(resolutionMaxValue).";
    static let vmLatitudeIsIncorrect = "The latitude must be between \(latitudeMinValue) and \(latitudeMaxValue).";
    static let vmLongitudeIsIncorrect = "The longitude must be between \(longitudeMinValue) and \(longitudeMaxValue).";
    static let vmNotSupportedValue = "This value currently is not supported."
    static let vmFinishEditing = "Please finish editing.";
    static let vmSetupElements = "Please setup all editable elements.";
    static let vmMismatchedParentheses = "Mismatched parentheses in expression."
    static let vmEmptyParentheses = "Empty parentheses in expression."
    static let vmInvalidExpressionStructure = "Invalid expression structure."
    static let vmUnexpectedToken = "Unexpected: %1$@."
    static let vmEmptyExpression = "Expression cannot be empty."
    static let vmExpressionParsingError = "Error when parsing expression: %1$@."
    static let vmEmptyFilename = "Filename cannot be empty."
    static let vmInvalidCharactersFilename = "Filename contains invalid characters (e.g., / or control characters)."
    static let vmTooLongFilename = "Filename is too long (max \(maxFileNameLength) UTF-16 code units)."
    static let vmFilenameStartsOrEndsWithSpace = "Filename cannot start or end with a space."
    static let vmFilenameEndsWithDot = "Filename cannot end with a dot."
    static let vmFilenameStartsWithDot = "Filename starts with a dot, which will be hidden on macOS."
    static let vmFilenameMustHaveExtension = "Add extension element to the end or setup an extension with custom text element."
    static let vmInvalidCharactersFolderPath = "Folder path contains invalid characters (e.g., control characters or null)."
    static let vmFolderPathContainsMultipleSlashes = "Folder path cannot contain multiple slashes."
    static let vmTooLongPath = "Folder path is too long (max \(maxFolderPathLength) UTF-16 code units)."
    static let vmTooLongPathComponent = "Folder name like '%1$@' is too long (max \(maxFileNameLength) UTF-16 code units)."
    static let vmPathComponentStartsOrEndsWithSpace = "Folder name like '%1$@' cannot start or end with a space."
    static let vmPathComponentEndsWithDot = "Folder name like '%1$@' cannot end with a dot."
    static let vmPathComponentStartsWithDot = "Folder name like '%1$@' starts with a dot, which will be hidden on macOS."
    static let vmNoActions = "Add at least one action or remove rule."
    static let vmActionsMess = "The 'Skip' or 'Delete' actions should not be combined with others."
    static let vmCopyMoveActionsMess = "There should only be one 'Copy to Folder' or 'Move to Folder' action per rule."
    static let vmExtraSkipOrDeleteAction = "The 'Skip' or 'Delete' actions should only appear once."
    static let vmExtraRenameAction = "The 'Rename' action should only appear once."
    static let vmExtraCopyToFolderAction = "The 'Copy to Folder' action should only appear once."
    static let vmExtraMoveToFolderAction = "The 'Move to Folder' action should only appear once."
    
    // MARK: Element names
    static let elInfo = "Info"
    static let elJobSettings = "Job settings"
    static let elGeneral = "General"
    static let elRules = "Rules"
    static let elAddJob = "Add job"
    static let elEditJob = "Edit job"
    static let elChoose = "Choose..."
    static let elJobName = "Job name"
    static let elConditions = "Conditions"
    static let elActions = "Actions"
    static let elNoConditions = "No conditions"
    static let elNoActions = "No actions"
    static let elActionPreview = "Action example: "
    static let elConditionPreview = "Condition example: "
    static let elCompleted = " completed "
    static let elCanceled = " cancelled "
    static let elNotYetRun = " not yet run "
    static let elAnalyzingFiles = "Analyzing files..."
    
    // MARK: Masks
    static let maskSource =  "Source: %1$@"
    static let maskOutput =  "Output: %1$@"
    
    // MARK: Toolbars
    static let toolbarRunJobs = "Run checked inactive jobs"
    static let toolbarAbortActiveJobs = "Abort active jobs"
    static let toolbarAddJob = "Add job"
    static let toolbarRemoveJob = "Remove job"
    static let toolbarAddRule = "Add rule"
    static let toolbarRemoveRule = "Remove rule"
    
    // MARK: Stubs
    static let stubNotSelected = "not selected yet"
    
    // MARK: Hints
    static let hintFolder = "Select a folder..."
    static let hintJobName = "A job name"
    static let hintCustomText = "Custom text"
    static let hintRunJob = "Run '%1$@' job"
    static let hintAbortJob = "Abort '%1$@' job"
    
    // MARK: Drag and Drop
    static let ddFolder = "public.file-url"
    
    // MARK: Dialogs
    static let dialogHeaderRemoveJob = "Delete job '%1$@'"
    static let dialogBodyRemoveJob = "This operation cannot be undone.\nThe folders will be preserved."
    static let dialogHeaderRemoveRule = "Delete rule"
    static let dialogBodyRemoveRule = "This operation cannot be undone."
    static let dialogHeaderCompleteAction = "Complete the action."
    static let dialogBodyCompleteAction = "Some changes are not completed. Please complete or reject them before closing this window."
    static let dialogButtonDelete = "Remove"
    static let dialogButtonCancel = "Cancel"
    static let dialogButtonOk = "OK"
    
    // MARK: About
    static let aboutSupportMail = "bWlyaGFtQGFidi5iZw=="
    static let aboutGitHubLink = "https://github.com/mirham/MediaOrganizer"
    
    static let aboutBackground = "AppInfo"
    
    static let aboutVersionKey = "CFBundleShortVersionString"
    static let aboutGetSupport = "Get support:"
    static let aboutVersion = "Version: %1$@"
    static let aboutMailTo = "mailto:%1$@"
    static let aboutGitHub = "GitHub"
}
