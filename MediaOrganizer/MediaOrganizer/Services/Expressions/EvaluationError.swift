//
//  EvaluationError.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 10.06.2025.
//

import Foundation

enum EvaluationError: Error, LocalizedError {
    case missingStrategy(String)
    case unexpectedOperator(ExpressionElementType)
    case invalidGroupStructure
    
    var errorDescription: String? {
        switch self {
            case .missingStrategy(let elementTypeId):
                return "No strategy found for element type: \(elementTypeId)"
            case .unexpectedOperator(let op):
                return "Unexpected logical operator: \(op)"
            case .invalidGroupStructure:
                return "Invalid group structure in AST"
        }
    }
}
