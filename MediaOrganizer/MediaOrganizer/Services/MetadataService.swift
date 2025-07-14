//
//  MetadataService.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 10.10.2024.
//

import Foundation
import ImageIO
import AVFoundation

class MetadataService: ServiceBase, MetadataServiceType {
    func getFileMetadataAsync(fileUrl: URL) async -> [MetadataType: Any?] {
        var result = [MetadataType: Any?]()
        
        guard fileUrl.isImageFile || fileUrl.isVideoFile else { return result }
        
        if fileUrl.isImageFile {
            result = getImageMetadata(fileUrl: fileUrl)
        }
        
        if fileUrl.isVideoFile {
            result = await getVideoMetadataAsync(fileUrl: fileUrl)
        }
        
        result[MetadataType.fileName] = fileUrl.deletingPathExtension().lastPathComponent
        result[MetadataType.fileExtension] = fileUrl.pathExtension
        
        do {
            let attributes:[FileAttributeKey:Any] = try FileManager.default
                .attributesOfItem(atPath: fileUrl.path(percentEncoded: false))
            let modificationDate = attributes[FileAttributeKey.modificationDate] as? Date
            let creationDate = attributes[FileAttributeKey.creationDate] as? Date
            result[MetadataType.fileDateCreated] = creationDate
            result[MetadataType.fileDateModified] = modificationDate
        } catch {
            // TODO: Log needed
            print("Error getting attributes of file.")
        }
        
        return result
    }
    
    // MARK: Private functions
    
    private func getImageMetadata(fileUrl: URL) -> [MetadataType: Any?] {
        var result = [MetadataType: Any?]()
        
        if let data = NSData(contentsOf: fileUrl) {
            let options = [kCGImageSourceShouldCache as String: kCFBooleanFalse]
            
            if let imgSrc = CGImageSourceCreateWithData(data, options as CFDictionary) {
                if let metadata = CGImageSourceCopyPropertiesAtIndex(imgSrc, 0, options as CFDictionary) as? NSDictionary {
                    result[MetadataType.metadataPixelXDimention] = metadata[kCGImagePropertyPixelWidth] as? Double
                    result[MetadataType.metadataPixelYDimention] = metadata[kCGImagePropertyPixelHeight] as? Double
                    
                    if let exifData = metadata[kCGImagePropertyExifDictionary] as? NSDictionary {
                        result[MetadataType.metadataDateDigitilized] = exifData[kCGImagePropertyExifDateTimeDigitized] as? String
                        result[MetadataType.metadataDateOriginal] = exifData[kCGImagePropertyExifDateTimeOriginal] as? String
                        result[MetadataType.metadataCameraModel] = exifData[kCGImagePropertyExifLensModel] as? String
                    }
                    
                    if let gpsData = metadata[kCGImagePropertyGPSDictionary] as? NSDictionary {
                        result[MetadataType.metadataLatitude] = gpsData[kCGImagePropertyGPSLatitude] as? Double
                        result[MetadataType.metadataLongitude] = gpsData[kCGImagePropertyGPSLongitude] as? Double
                    }
                }
            }
        }
        
        return result
    }
    
    private func getVideoMetadataAsync(fileUrl: URL) async -> [MetadataType: Any?] {
        var result = [MetadataType: Any?]()
        
        let asset = AVURLAsset(url: fileUrl)
            
        do {
            let iTunesMetadata = try await asset.loadMetadata(for: .quickTimeMetadata)
            
            let cameraModelMetadata = AVMetadataItem.metadataItems(
                from: iTunesMetadata,
                filteredByIdentifier: .quickTimeMetadataModel).first
            
            let cameraModel = try await cameraModelMetadata?.load(.stringValue)
            result[MetadataType.metadataCameraModel] = cameraModel
            
            
            let creationDateMetadata = AVMetadataItem.metadataItems(
                from: iTunesMetadata,
                filteredByIdentifier: .quickTimeMetadataCreationDate).first
            let creationDate = try await creationDateMetadata?.load(.dateValue)
            result[MetadataType.metadataDateOriginal] = creationDate
            result[MetadataType.metadataDateDigitilized] = result[MetadataType.metadataDateOriginal]
            
            
            let track = try await AVURLAsset(url: fileUrl)
                .loadTracks(withMediaType: AVMediaType.video).first
            let size = try await track?.load(.naturalSize)
                .applying(track!.load(.preferredTransform))
            result[MetadataType.metadataPixelXDimention] = size?.width
            result[MetadataType.metadataPixelYDimention] = size?.height
            
            let locationMetadata = AVMetadataItem.metadataItems(from: iTunesMetadata, filteredByIdentifier: .quickTimeMetadataLocationISO6709).first
            
            let locationString = try await locationMetadata?.load(.value)
            let location = IsoString.parseFromIso6709String(
                iso6709String: locationString?.description)
            result[MetadataType.metadataLatitude] = location?.coordinate.latitude
            result[MetadataType.metadataLongitude] = location?.coordinate.longitude
        }
        catch {
            let desc = error.localizedDescription
            print(desc)
        }
        
        return result
    }
}
