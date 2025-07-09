//
//  ASTError.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 03.06.2025.
//

enum ASTError: Error {
    case mismatchedParentheses
    case emptyParentheses
    case invalidExpression
    case unexpectedToken(String)
    case emptyExpression
    
    var errorDescription: String {
        switch self {
            case .mismatchedParentheses:
                return Constants.vmMismatchedParentheses
            case .emptyParentheses:
                return Constants.vmEmptyParentheses
            case .invalidExpression:
                return Constants.vmInvalidExpressionStructure
            case .unexpectedToken(let token):
                return String(format: Constants.vmUnexpectedToken, token)
            case .emptyExpression:
                return Constants.vmEmptyExpression
        }
    }
}
