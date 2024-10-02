//
//  MetadataType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import Foundation

enum MetadataType : Int, CaseIterable, Identifiable, Codable, Equatable {
    var id: Int { return self.rawValue }
    
    case fileName = 10
    case fileDateCreated = 11
    case fileDateModified = 12
    case exifDateOriginal = 13
    case exifDateDigitilized = 14
    case exifCameraModel = 15
    case exifPixelXDimention = 16
    case exifPixelYDimention = 17
    case exifLatitude = 18
    case exifLongitude = 19
    
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
    
    var shortDescription: String {
        switch self {
            case .fileName: return "name"
            case .fileDateCreated: return "date created"
            case .fileDateModified: return "date modified"
            case .exifDateOriginal: return "date original"
            case .exifDateDigitilized: return "date digitilized"
            case .exifCameraModel: return "camera model"
            case .exifPixelXDimention: return "width"
            case .exifPixelYDimention: return "height"
            case .exifLatitude: return "latitude"
            case .exifLongitude: return "longitude"
        }
    }
}
