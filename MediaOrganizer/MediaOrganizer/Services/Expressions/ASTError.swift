//
//  ASTError.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 03.06.2025.
//

enum ASTError: Error {
    case mismatchedParentheses
    case invalidExpression
    case unexpectedToken(String)
    case emptyExpression
    
    var errorDescription: String? {
        switch self {
            case .mismatchedParentheses:
                return "Mismatched parentheses in expression"
            case .invalidExpression:
                return "Invalid expression structure"
            case .unexpectedToken(let token):
                return "Unexpected token: \(token)"
            case .emptyExpression:
                return "Expression cannot be empty"
        }
    }
}
