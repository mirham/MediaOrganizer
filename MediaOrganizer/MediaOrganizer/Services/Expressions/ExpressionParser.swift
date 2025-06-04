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
        var tokens = elements
        var output: [ASTNode] = []
        var operators: [ASTNode] = []
        
        while !tokens.isEmpty {
            let token = tokens.removeFirst()
            if let exprType = ExpressionElementType(rawValue: token.elementTypeId) {
                switch exprType {
                    case .and, .or:
                        let opNode = ASTNode.logical(exprType, [])
                        while let lastOp = operators.last,
                              case .logical(let lastOpType, _) = lastOp,
                              lastOpType != .leftParen,
                              precedence(of: lastOpType) >= precedence(of: exprType) {
                            operators.removeLast()
                            output.append(lastOp)
                        }
                        operators.append(opNode)
                    case .leftParen:
                        operators.append(.group([]))
                    case .rightParen:
                        while let lastOp = operators.last,
                              case .logical(let lastOpType, _) = lastOp,
                              lastOpType != .leftParen {
                            operators.removeLast()
                            output.append(lastOp)
                        }
                        if let lastOp = operators.last,
                           case .group = lastOp {
                            operators.removeLast()
                            output.append(.group([buildNode(from: &output)]))
                        } else {
                            throw ASTError.mismatchedParentheses
                        }
                }
            } else {
                output.append(.comparison(token))
            }
        }
        
        while let op = operators.popLast() {
            if case .group = op {
                output.append(.group([buildNode(from: &output)]))
            } else {
                output.append(op)
            }
        }
        
        return buildNode(from: &output)
    }
    
    private func precedence(of exprType: ExpressionElementType) -> Int {
        switch exprType {
            case .and: return 2
            case .or: return 1
            case .leftParen, .rightParen: return 0
        }
    }
    
    private func buildNode(from output: inout [ASTNode]) -> ASTNode {
        guard let node = output.popLast() else {
            return .empty
        }
        switch node {
            case .logical(let op, _):
                let right = buildNode(from: &output)
                let left = buildNode(from: &output)
                return .logical(op, [left, right].filter { $0 != .empty })
            case .group(let children):
                return .group(children)
            default:
                return node
        }
    }
}
