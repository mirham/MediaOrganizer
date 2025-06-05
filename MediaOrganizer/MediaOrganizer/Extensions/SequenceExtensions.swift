//
//  SequenceExtensions.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 05.06.2025.
//

import Foundation

extension Sequence {
    func asyncForEach(_ operation: (Element) async throws -> Void) async rethrows {
        for element in self {
            try await operation(element)
        }
    }
    
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else { return [] }
        var result: [[Element]] = []
        var currentChunk: [Element] = []
        var iterator = makeIterator()
        
        while let element = iterator.next() {
            currentChunk.append(element)
            if currentChunk.count == size {
                result.append(currentChunk)
                currentChunk = []
            }
        }
        
        if !currentChunk.isEmpty {
            result.append(currentChunk)
        }
        
        return result
    }
}
