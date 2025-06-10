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
    
    // TODO: Kept for debugging, remove in the future.
    func printStructure(indent: Int = 0) -> String {
        let indentation = String(repeating: "  ", count: indent)
        
        switch self {
            case .empty:
                return "\(indentation)Empty"
            case .logical(let op, let children):
                var result = "\(indentation)Logical(\(op))\n"
                for child in children {
                    result += child.printStructure(indent: indent + 1) + "\n"
                }
                return result
            case .comparison(let element):
                return "\(indentation)Comparison(elementTypeId: \(element.elementTypeId))"
            case .group(let children):
                var result = "\(indentation)Group\n"
                for child in children {
                    result += child.printStructure(indent: indent + 1) + "\n"
                }
                return result
        }
    }
    
    // TODO: Kept for debugging, remove in the future.
    func printOutput(indent: Int = 0, _ elementStrategyFactory: ElementStrategyFactoryType) {
        let indentation = String(repeating: "  ", count: indent)
        
        switch self {
            case .empty:
                print("\(indentation)Empty (true)")
            case .logical(let op, let children):
                do {
                    let result = try evaluate(elementStrategyFactory)
                    print("\(indentation)Logical (\(op)) -> \(result)")
                } catch {
                    print("\(indentation)Logical (\(op)) -> ERROR: \(error.localizedDescription)")
                }
                for child in children {
                    child.printOutput(indent: indent + 1, elementStrategyFactory)
                }
            case .comparison(let element):
                do {
                    let result = try evaluate(elementStrategyFactory)
                    print("\(indentation)Comparison (\(MetadataType(rawValue: element.elementTypeId)?.shortDescription ?? "unknown")) -> \(result)")
                } catch {
                    print("\(indentation)Comparison (\(MetadataType(rawValue: element.elementTypeId)?.shortDescription ?? "unknown")) -> ERROR: \(error.localizedDescription)")
                }
                
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
                do {
                    let result = try evaluate(elementStrategyFactory)
                    print("\(indentation)Group -> \(result)")
                } catch {
                    print("\(indentation)Group -> ERROR: \(error.localizedDescription)")
                }
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
