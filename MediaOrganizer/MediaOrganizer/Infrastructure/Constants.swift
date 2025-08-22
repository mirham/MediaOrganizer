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
    static let defaultAppBundleName = "com.mirham.MediaOrganizer"
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
    static let logFileNameMask = "job_%1$@.log"
    static let loggerQueueLabel = "\(Bundle.main.bundleIdentifier!).logger"
    static let loggerDomainName = "MediaOrganizer_Logger"
    static let defaultLogFileLimit: Int = 10000
    static let exifDateFormat = "yyyy:MM:dd HH:mm:ss"
    
    // MARK: Symbols and strings
    static let space = "   "
    static let spaceShort = " "
    static let slash = "/"
    static let slashChar: Character = "/"
    static let dot = "."
    static let hyphen = "-"
    static let comma = ","
    static let nullChar = "\0"
    static let colon = ":"
    static let sharp = "#"
    static let newLine = "\n"
    static let info = "🟢"
    static let warning = "🟠"
    static let error = "🔴"
    static let infoChar: Character = "🟢"
    static let warningChar: Character = "🟠"
    static let errorChar: Character = "🔴"
    
    // MARK: Settings key names
    static let settingsKeyJobs = "jobs"
    
    // MARK: Window IDs
    static let windowIdMain = "main-view"
    static let windowIdJobSettings = "job-settings-view"
    static let windowIdInfo = "info-view"
    static let windowIdLog = "log-view"
    
    // MARK: Icons
    static let iconApp = "AppIcon"
    static let iconRun = "play.fill"
    static let iconArrowForward = "arrow.forward"
    static let iconAdd = "plus.circle.fill"
    static let iconDuplicate = "rectangle.on.rectangle.circle.fill"
    static let iconRemove = "minus.circle.fill"
    static let iconSettings = "gear.circle.fill"
    static let iconCheckmark = "checkmark.circle.fill"
    static let iconCircle = "circle"
    static let iconCheck = "checkmark.circle.fill"
    static let iconEdit = "pencil.circle.fill"
    static let iconFile = "doc.fill"
    static let iconStop = "stop.fill"
    static let iconCancel = "xmark.circle.fill"
    static let iconWarning = "exclamationmark.circle.fill"
    static let iconError = "xmark.circle.fill"
    static let iconUp = "arrowshape.up.circle.fill"
    static let iconDown = "arrowshape.down.circle.fill"
    static let iconInfo = "info.circle.fill"
    
    // MARK: Colors
    static let colorHexSelection = "#244EC9"
    static let colorHexPanelDark = "#313131"
    static let colorHexPanelLight = "#ECECEC"
    static let colorHexFileElement = "#681892"
    static let colorHexExifElement = "#093576"
    static let colorHexCustomElement = "#C49518"
    static let colorHexExpressionElement = "#39C43A"
    
    // MARK: Regexes
    static let regexLocationInIso6709 = "([+-][0-9.]+)([+-][0-9.]+)"
    static let regexEncodedLocationInIso6709 = "%+09.5f%+010.5f%+.0fCRSWGS_84/"
    static let regexSlash = /\//
    static let regexTwoSlashes = /\/\//
    static let regexSearchCopySuffix = "\(Constants.elCopy)\\s*\\d*\\s*$"
    static let regexSearchCopySuffixToReplace = "\(Constants.elCopy)\\s*\\d+\\s*$"
    
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
    static let defaultLogEntryDateFormat = "yyyy-MM-dd HH:mm:ss"
    static let dateMinValueString = "1900/01/01 00:00:00"
    static let dateMaxValueString = "2100/12/31 23:59:59"
    
    // MARK: Element names
    static let elInfo = "Info"
    static let elAbout = "About"
    static let elJobSettings = "Job settings: %1$@"
    static let elGeneral = "General"
    static let elRules = "Rules"
    static let elAddJob = "Add job"
    static let elEditJob = "Edit job"
    static let elChoose = "Choose..."
    static let elJobName = "Job name"
    static let elJobs = "Jobs"
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
    static let elChecked = "Checked"
    static let elUnchecked = "Unchecked"
    static let elJobLog = "Job log: %1$@"
    static let elShowLogInFolder = "Show in folder"
    static let elClear = "Clear"
    static let elCopy = "Copy"
    static let elDuplicatesPolicy = "Duplicates policy"
    static let elIsNotAvailable = "not available"
    static let elNoJobs = "No jobs, add a new one"
    static let elNoRules = "No rules, add a new one"
    
    // MARK: Masks
    static let maskSource =  "Source: %1$@"
    static let maskOutput =  "Output: %1$@"
    
    // MARK: Toolbars
    static let toolbarRunJobs = "Run checked inactive jobs"
    static let toolbarAbortActiveJobs = "Abort active jobs"
    static let toolbarAdd = "Add"
    static let toolbarRemove = "Remove"
    static let toolbarUp = "Up"
    static let toolbarDown = "Down"
    static let toolbarDuplicate = "Duplicate"
    static let toolbarEdit = "Edit"
    
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
    
    // MARK: Hints
    static let hintRules = "Rules are applied sequentially\nSet up more specific rules, then more general ones\nIf rules cannot be applied or an error occurs, the files are left untouched"
    static let hintElements = "Drag and drop elements to customize them as you like, drag them back to remove them."
    
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
    static let vmEmptyCondition = "Set up or remove empty conditions."
    static let vmActionsMess = "The 'Skip' or 'Delete' actions should not be combined with others."
    static let vmCopyMoveActionsMess = "There should only be one 'Copy to Folder' or 'Move to Folder' action per rule."
    static let vmExtraSkipOrDeleteAction = "The 'Skip' or 'Delete' actions should only appear once."
    static let vmExtraRenameAction = "The 'Rename' action should only appear once."
    static let vmExtraCopyToFolderAction = "The 'Copy to Folder' action should only appear once."
    static let vmExtraMoveToFolderAction = "The 'Move to Folder' action should only appear once."
    static let vmCannotParseArray = "Unable to parse array values. Make sure there is more than one value and they are separated by a comma."
    
    // MARK: Log messages
    static let lmJobCancelled = "The job has been cancelled."
    static let lmJobFailed = "The job has been failed with error: %1$@"
    static let lmFileSkipped = "File '%1$@' skipped."
    static let lmFileRenamingSkipped = "Renaming file '%1$@' was skipped, it already has a proper name."
    static let lmFileSkippedDestinationExists = "File '%1$@' skipped and restored as '%2$@', because of destination file '%3$@' already exists \(lmAccordingToPolicy)."
    static let lmFileWasRenamed = "File '%1$@' was renamed to '%2$@'."
    static let lmFileWasCopied = "File '%1$@' was copied to '%2$@'."
    static let lmFileWasMoved = "File '%1$@' was moved to '%2$@'."
    static let lmFileWasOverwritten = "File '%1$@' was overwritten \(lmAccordingToPolicy)."
    static let lmFileWasDeleted = "File '%1$@' was deleted."
    static let lmAccordingToPolicy = "(according to policy)"
    static let lmCannotMakeFileAction = "Unable to perform action '%1$@' on file '%2$@', rule %3$@ will be skipped."
    
    // MARK: Errors
    static let errorNoStrategyForElementType = "No strategy found for element type: %1$@."
    static let errorUnexpectedLogicalOperator = "Unexpected logical operator: %1$@."
    static let errorAstInvalidGroupStructure = "Invalid structure of syntax three."
    static let errorFailedToClearLogFile = "Failed to clear log file: %1$@"
    static let errorReadingLogFile = "Error reading log file: %1$@"
    static let errorInvalidConditionValueType = "Invalid condition value type: %1$@."
    static let errorCannotCreateFolder = "Cannot create folder '%1$@': %2$@."
    static let errorCannotPerformAction = "Cannot %1$@ file '%2$@': %3$@."
    static let errorCannotPerformAction2 = "Cannot perform action with file '%1$@': %2$@."
    static let errorCannotApplyRule = "Cannot apply rule %1$@: %2$@."
    static let errorCannotPerformFileAction = "Cannot perform file action '%1$@'"
    static let errorFatalCannotRestoreFile = "Uh-oh, fatal error here! Cannot restore file '%1$@'!"
    
    // MARK: About
    static let aboutSupportMail = "bWlyaGFtQGFidi5iZw=="
    static let aboutGitHubLink = "https://github.com/mirham/MediaOrganizer"
    
    static let aboutBackground = "AppInfo"
    
    static let aboutVersionKey = "CFBundleShortVersionString"
    static let aboutGetSupport = "Get support:"
    static let aboutVersion = "Version: %1$@"
    static let aboutMailTo = "mailto:%1$@"
    static let aboutGitHub = "GitHub"
    
    // MARK: Static data
    static let exampleDateComponents = DateComponents(
        timeZone: TimeZone(identifier: "Europe/Sofia"),
        year: 2025,
        month: 05,
        day: 01,
        hour: 09,
        minute: 01,
        second: 05
    )
}
