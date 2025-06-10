//
//  ExpressionParser.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 03.06.2025.
//

struct ExpressionParser {
    private let elements: [ConditionElement]
    
    init(elements: [ConditionElement]) {
        self.elements = elements
    }
    
    func parse() throws -> ASTNode {
        guard !elements.isEmpty else {
            throw ASTError.emptyExpression
        }
        
        let tokens = tokenize()
        return try parseTokens(tokens)
    }
    
    // MARK: Private functions
    
    private func tokenize() -> [Token] {
        return elements.map { element in
            if let exprType = ExpressionElementType(rawValue: element.elementTypeId) {
                switch exprType {
                    case .and, .or:
                        return .op(exprType)
                    case .leftParen:
                        return .leftParen
                    case .rightParen:
                        return .rightParen
                }
            } else {
                return .operand(element)
            }
        }
    }
    
    private func parseTokens(_ tokens: [Token]) throws -> ASTNode {
        var tokenQueue = tokens
        var outputQueue: [ASTNode] = []
        var operatorStack: [Token] = []
        
        while !tokenQueue.isEmpty {
            let token = tokenQueue.removeFirst()
            
            switch token {
                case .operand(let element):
                    outputQueue.append(.comparison(element))
                case .op(let op):
                    while let stackTop = operatorStack.last,
                          case .op(let stackOp) = stackTop,
                          precedence(of: stackOp) >= precedence(of: op) {
                        operatorStack.removeLast()
                        try processOperator(stackOp, outputQueue: &outputQueue)
                    }
                    operatorStack.append(token)
                    
                case .leftParen:
                    operatorStack.append(token)
                    
                case .rightParen:
                    var foundLeftParen = false
                    while let stackTop = operatorStack.last {
                        operatorStack.removeLast()
                        if case .leftParen = stackTop {
                            foundLeftParen = true
                            break
                        } else if case .op(let op) = stackTop {
                            try processOperator(op, outputQueue: &outputQueue)
                        }
                    }
                    
                    if !foundLeftParen {
                        throw ASTError.mismatchedParentheses
                    }
            }
        }
        
        while let stackTop = operatorStack.last {
            operatorStack.removeLast()
            switch stackTop {
                case .leftParen, .rightParen:
                    throw ASTError.mismatchedParentheses
                case .op(let op):
                    try processOperator(op, outputQueue: &outputQueue)
                case .operand:
                    break
            }
        }
        
        return try buildFinalNode(from: outputQueue)
    }
    
    private func processOperator(_ op: ExpressionElementType, outputQueue: inout [ASTNode]) throws {
        guard outputQueue.count >= 2 else {
            throw ASTError.invalidExpression
        }
        
        let right = outputQueue.removeLast()
        let left = outputQueue.removeLast()
        let logicalNode = ASTNode.logical(op, [left, right])
        outputQueue.append(logicalNode)
    }
    
    private func buildFinalNode(from outputQueue: [ASTNode]) throws -> ASTNode {
        guard outputQueue.count == 1 else {
            if outputQueue.isEmpty {
                return .empty
            } else {
                throw ASTError.invalidExpression
            }
        }
        
        return outputQueue[0]
    }
    
    private func precedence(of exprType: ExpressionElementType) -> Int {
        switch exprType {
            case .and: return 2
            case .or: return 1
            case .leftParen, .rightParen: return 0
        }
    }
    
    // MARK: Inner types
    
    private enum Token {
        case operand(ConditionElement)
        case op(ExpressionElementType)
        case leftParen
        case rightParen
    }
}
