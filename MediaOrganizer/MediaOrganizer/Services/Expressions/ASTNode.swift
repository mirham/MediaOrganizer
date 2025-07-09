//
//  ASTNode.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 03.06.2025.
//

import Foundation
import Factory

enum ASTNode: Equatable {
    case empty
    case logical(ExpressionElementType, [ASTNode])
    case comparison(ConditionElement)
    case group([ASTNode])
    
    func validate() -> Bool {
        switch self {
            case .empty:
                return true
            case .logical(_, let children):
                return children.count >= 2 && children.allSatisfy { $0.validate() }
            case .comparison:
                return true
            case .group(let children):
                return children.count == 1 && children[0].validate()
        }
    }

    func evaluate(_ elementStrategyFactory: ElementStrategyFactoryType) throws -> Bool {
        switch self {
            case .empty:
                return true
                
            case .logical(let op, let children):
                guard !children.isEmpty else { return true }
                
                switch op {
                    case .and:
                        return try children.allSatisfy { try  $0.evaluate(elementStrategyFactory) }
                    case .or:
                        return try children.contains { try $0.evaluate(elementStrategyFactory) }
                    default:
                        throw EvaluationError.unexpectedOperator(op)
                }
                
            case .comparison(let element):
                guard let strategy = elementStrategyFactory.getStrategy(elementTypeKey: element.elementTypeId) else {
                    throw EvaluationError.missingStrategy(element.elementTypeId.description)
                }
                return strategy.checkCondition(context: element)
                
            case .group(let children):
                guard !children.isEmpty else { return true }
                guard children.count == 1 else {
                    throw EvaluationError.invalidGroupStructure
                }
                return try children[0].evaluate(elementStrategyFactory)
        }
    }
    
    static func == (lhs: ASTNode, rhs: ASTNode) -> Bool {
        switch (lhs, rhs) {
            case (.empty, .empty):
                return true
            case (.logical(let op1, let children1), .logical(let op2, let children2)):
                return op1 == op2 && children1 == children2
            case (.comparison(let elem1), .comparison(let elem2)):
                return elem1 == elem2
            case (.group(let children1), .group(let children2)):
                return children1 == children2
            default:
                return false
        }
    }
}
