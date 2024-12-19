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
    case fileExtension = 11
    case fileDateCreated = 12
    case fileDateModified = 13
    case metadataDateOriginal = 14
    case metadataDateDigitilized = 15
    case metadataCameraModel = 16
    case metadataPixelXDimention = 17
    case metadataPixelYDimention = 18
    case metadataLatitude = 19
    case metadataLongitude = 20
    
    var description: String {
        switch self {
            case .fileName: return "file name"
            case .fileExtension: return "file extension"
            case .fileDateCreated: return "file date created"
            case .fileDateModified: return "file date modified"
            case .metadataDateOriginal: return "metadata date original"
            case .metadataDateDigitilized: return "metadata date digitilized"
            case .metadataCameraModel: return "metadata camera model"
            case .metadataPixelXDimention: return "metadata width"
            case .metadataPixelYDimention: return "metadata height"
            case .metadataLatitude: return "metadata latitude"
            case .metadataLongitude: return "metadata longitude"
        }
    }
    
    var shortDescription: String {
        switch self {
            case .fileName: return "name"
            case .fileExtension: return "extension"
            case .fileDateCreated: return "date created"
            case .fileDateModified: return "date modified"
            case .metadataDateOriginal: return "date original"
            case .metadataDateDigitilized: return "date digitilized"
            case .metadataCameraModel: return "camera model"
            case .metadataPixelXDimention: return "width"
            case .metadataPixelYDimention: return "height"
            case .metadataLatitude: return "latitude"
            case .metadataLongitude: return "longitude"
        }
    }
    
    var example: String {
        switch self {
            case .fileName: return "IMG_013777"
            case .fileExtension: return ".HEIC"
            case .metadataCameraModel: return "iPhone 15 Pro Max"
            case .metadataPixelXDimention: return "4032"
            case .metadataPixelYDimention: return "2268"
            case .metadataLatitude: return "53° 15' 54,93\" E"
            case .metadataLongitude: return "56° 50' 57,3\" N"
            default: return shortDescription
        }
    }
}
