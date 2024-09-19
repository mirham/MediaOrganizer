//
//  MetadataType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import Foundation

enum MetadataType : Int, CaseIterable, Identifiable, Codable, Equatable {
    var id: Int { return self.rawValue }
    
    case fileName = 0
    case fileDateCreated = 1
    case fileDateModified = 2
    case exifDateOriginal = 3
    case exifDateDigitilized = 4
    case exifCameraModel = 5
    case exifPixelXDimention = 6
    case exifPixelYDimention = 7
    case exifLatitude = 8
    case exifLongitude = 9
    
    var description: String {
        switch self {
            case .fileName: return "file name"
            case .fileDateCreated: return "file date created"
            case .fileDateModified: return "file date modified"
            case .exifDateOriginal: return "EXIF date original"
            case .exifDateDigitilized: return "EXIF date digitilized"
            case .exifCameraModel: return "EXIF camera model"
            case .exifPixelXDimention: return "EXIF width"
            case .exifPixelYDimention: return "EXIF height"
            case .exifLatitude: return "EXIF latitude"
            case .exifLongitude: return "EXIF longitude"
        }
    }
}
