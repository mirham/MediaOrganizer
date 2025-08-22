<p align="center">
  <img src="https://github.com/mirham/MediaOrganizer/blob/main/Images/AppLogo.png" width="500"/>
</p>

<p align="center" style="text-align: center">
  <a href="https://github.com/mirham/MediaOrganizer/tags" rel="nofollow">
    <img alt="GitHub tag (latest SemVer pre-release)" src="https://img.shields.io/github/v/tag/mirham/MediaOrganizer?include_prereleases&label=version"/>
  </a>
  <a href="https://github.com/mirham/MediaOrganizer/blob/main/LICENSE">
    <img alt="License" src="https://img.shields.io/github/license/mirham/MediaOrganizer"/>
  </a>
  <img alt="macOS" src="https://img.shields.io/badge/macOS-blue?logo=apple"/>
  <img alt="Swift" src="https://img.shields.io/badge/Swift-grey?logo=swift"/>
  <img alt="Pet project" src="https://img.shields.io/badge/Pet project-purple?logo=github"/>
</p>

## Introduction
If you're into photography, you're likely aware of how challenging it can be to organize your photos and videos. Each device has its own naming format, and most aren't adjustable (I'm looking at you, iPhone and GoPro). For instance, after a family trip to France, collecting all the media from various devices can leave you with thousands of disorganized files. Manually sorting through that mess can be incredibly time-consuming, especially if you have a strict file structure and naming rules.

You'd probably need a few applications to rename and move files, like Adobe Lightroom Classic. However, purchasing expensive software just for these operations isn't always a reasonable choice.

Personally, I've organized my media archive with this structure:
```
Year
|-- Month.Day
|   |-- Videos
|   |   |-- dd.MM.yyyy hh-mm-ss.Extension
|   |   |-- dd.MM.yyyy hh-mm-ss.Extension
|   |-- dd.MM.yyyy hh-mm-ss_DeviceName.Extension
|   |-- dd.MM.yyyy hh-mm-ss_DeviceName.Extension
```

In the past, I used this combination of software:
- Renamer - to rename files
- A custom Automator's AppleScript - to move files into the correct folders
- Finder's smart folders - for quick file filtering

This system worked, but even with all these tools, it took a long time to organize my files.

Eventually, I got fed up and decided to create the MirHam Media Organizer. My goal was to set up my media organization jobs once and then periodically run them with the click of a button. I'm now sharing it with everyone, and I hope this open-source program proves to be useful.

## Features
- Lets you organize photos and videos in any structure you prefer with desired file names
- Achieves this using file and EXIF data and a set of flexible rules
- Processes multiple jobs at the same time
- Rapidly processes large media collections thanks to parallel processing
- Automatically restores the original file in case of an error
- Detailed logs help you fine-tune jobs
- Supports both, light and dark theme

## Compatibility
This application is compatible with macOS 14.5 and above.

## Installation
Download the DMG installer from the [releases](https://github.com/mirham/MediaOrganizer/releases), mount it, and drag and drop the application to the Applications folder. That's it! However, you will need to allow launching applications from unidentified developers to start the application, as I don't have an Apple developer license.

## Screenshots

### Main view
<p align="left">
  <img src="https://github.com/mirham/MediaOrganizer/blob/main/Images/Main2.png" width="650">
</p>

### Job settings
<p align="left">
  <img src="https://github.com/mirham/MediaOrganizer/blob/main/Images/GeneralSettings.png" width="650">
  <img src="https://github.com/mirham/MediaOrganizer/blob/main/Images/Rules.png" width="650">
</p>

### Flexible rules
<p align="left">
  <img src="https://github.com/mirham/MediaOrganizer/blob/main/Images/RuleEdit.png" width="650">
</p>

Set up them as you wish
<p align="left">
  <img src="https://github.com/mirham/MediaOrganizer/blob/main/Images/ElementSetup.png" width="1000">
</p>

### Inline validation
<p align="left">
  <img src="https://github.com/mirham/MediaOrganizer/blob/main/Images/Validation.png" width="700">
</p>

### Job logs
<p align="left">
  <img src="https://github.com/mirham/MediaOrganizer/blob/main/Images/JobLog.png" width="700">
</p>

## Improvement
> [!TIP]
> If you have any ideas, thoughts, or concerns, don't hesitate to contact me. I'm happy to help and improve the application.

## Disclaimer
> [!WARNING]
> I'm not a professional Swift developer (though I am a professional .NET developer). All my macOS apps are made for personal use by myself and my family simply because I have the skills to create them (and for fun, of course 😊). If my application has caused any harm, I apologize for that, but please be aware that you use it at your own risk.
