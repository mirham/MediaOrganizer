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

    func evaluate(_ elementStrategyFactory: ElementStrategyFactoryType) -> Bool {
        switch self {
            case .empty:
                return true
            case .logical(let op, let children):
                switch op {
                    case .and:
                        return children.allSatisfy { $0.evaluate(elementStrategyFactory) }
                    case .or:
                        return children.contains { $0.evaluate(elementStrategyFactory) }
                    default:
                        return false
                }
            case .comparison(let element):
                if let strategy = elementStrategyFactory.getStrategy(elementTypeKey: element.elementTypeId) {
                    return strategy.checkCondition(context: element)
                }
                return false
            case .group(let children):
                return children.first?.evaluate(elementStrategyFactory) ?? true
        }
    }
    
    // TODO: Kept for debugging, remove in the future.
    func printOutput(indent: Int = 0, _ elementStrategyFactory: ElementStrategyFactoryType) {
        let indentation = String(repeating: "  ", count: indent)
        
        switch self {
            case .empty:
                print("\(indentation)Empty (true)")
            case .logical(let op, let children):
                let result = evaluate(elementStrategyFactory)
                print("\(indentation)Logical (\(op)) -> \(result)")
                for child in children {
                    child.printOutput(indent: indent + 1, elementStrategyFactory)
                }
            case .comparison(let element):
                let result = evaluate(elementStrategyFactory)
                let fieldName = MetadataType(rawValue: element.elementTypeId)?.shortDescription ?? "unknown"
                print("\(indentation)Comparison (\(fieldName)) -> \(result)")
                if let opId = element.selectedOperatorTypeId {
                    if let op = NumberAndDateOperatorType(rawValue: opId) {
                        print("\(indentation)  Operator: \(op)")
                    } else if let op = StringOperatorType(rawValue: opId) {
                        print("\(indentation)  Operator: \(op.description)")
                    }
                }
                
                let value = element.value
                
                switch value {
                    case .int(let val): print("\(indentation)  Value: \(val)")
                    case .double(let val): print("\(indentation)  Value: \(val)")
                    case .date(let val): print("\(indentation)  Value: \(val)")
                    case .string(let val): print("\(indentation)  Value: \"\(val)\"")
                }
                
                if let metadataType = MetadataType(rawValue: element.elementTypeId),
                   let rawFieldValue = element.fileMetadata[metadataType] {
                    switch element.settingType {
                        case .text:
                            if let str = rawFieldValue as? String {
                                print("\(indentation)  Field Value: \"\(str)\"")
                            }
                        case .number:
                            if let intVal = rawFieldValue as? Int {
                                print("\(indentation)  Field Value: \(intVal)")
                            }

                            if let doubleVal = rawFieldValue as? Double {
                                print("\(indentation)  Field Value: \(doubleVal)")
                            }
                        case .date:
                            if let dateVal = rawFieldValue as? Date {
                                print("\(indentation)  Field Value: \(dateVal)")
                            }
                    }
                }
            case .group(let children):
                let result = evaluate(elementStrategyFactory)
                print("\(indentation)Group -> \(result)")
                for child in children {
                    child.printOutput(indent: indent + 1, elementStrategyFactory)
                }
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
