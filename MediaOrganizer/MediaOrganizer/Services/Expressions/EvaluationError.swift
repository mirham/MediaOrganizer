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
                return String(format: Constants.errorNoStrategyForElementType, elementTypeId)
            case .unexpectedOperator(let op):
                return String(format: Constants.errorUnexpectedLogicalOperator, op.description)
            case .invalidGroupStructure:
                return Constants.errorAstInvalidGroupStructure
        }
    }
}
