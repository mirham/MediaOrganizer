//
//  ASTNode.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 03.06.2025.
//

import Foundation

enum ASTNode: Equatable {
    case empty
    case logical(ExpressionElementType, [ASTNode])
    case comparison(ConditionElement)
    case group([ASTNode])
    
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
    
    // Evaluate the AST
    func evaluate() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        switch self {
            case .empty:
                return true
            case .logical(let op, let children):
                switch op {
                    case .and:
                        return children.allSatisfy { $0.evaluate() }
                    case .or:
                        return children.contains { $0.evaluate() }
                    default:
                        return false
                }
            case .comparison(let element):
                guard let opId = element.selectedOperatorTypeId,
                      let metadataType = MetadataType(rawValue: element.elementTypeId),
                      let rawFieldValue = element.fileMetadata[metadataType] else {
                    return false
                }
                
                let value = element.value
                
                // Convert rawFieldValue to ConditionValue
                let fieldValue: ConditionValue?
                switch element.settingType {
                    case .text:
                        guard let str = rawFieldValue as? String else { return false }
                        fieldValue = .string(str)
                    case .number:
                        guard let intVal = rawFieldValue as? Int else { return false }
                        fieldValue = .int(intVal)
                    /*case .double:
                        guard let doubleVal = rawFieldValue as? Double else { return false }
                        fieldValue = .double(doubleVal) */
                    case .date:
                        guard let dateVal = rawFieldValue as? Date else { return false }
                        fieldValue = .date(dateVal)
                    default:
                        return false
                }
                
                guard let fieldVal = fieldValue else { return false }
                
                if let op = NumberAndDateOperatorType(rawValue: opId) {
                    switch (fieldVal, value) {
                        case (.int(let fieldInt), .int(let val)):
                            switch op {
                                case .equals: return fieldInt == val
                                case .notEquals: return fieldInt != val
                                case .greater: return fieldInt > val
                                case .less: return fieldInt < val
                                case .greaterOrEquals: return fieldInt >= val
                                case .lessOrEquals: return fieldInt <= val
                            }
                        case (.double(let fieldDouble), .double(let val)):
                            switch op {
                                case .equals: return fieldDouble == val
                                case .notEquals: return fieldDouble != val
                                case .greater: return fieldDouble > val
                                case .less: return fieldDouble < val
                                case .greaterOrEquals: return fieldDouble >= val
                                case .lessOrEquals: return fieldDouble <= val
                            }
                       case (.date(let fieldDate), .date(let val)):
                            switch op {
                                case .equals: return fieldDate == val
                                case .notEquals: return fieldDate != val
                                case .greater: return fieldDate > val
                                case .less: return fieldDate < val
                                case .greaterOrEquals: return fieldDate >= val
                                case .lessOrEquals: return fieldDate <= val
                            }
                        default:
                            return false // Type mismatch
                    }
                } else if let op = StringOperatorType(rawValue: opId) {
                    guard case .string(let fieldStr) = fieldVal,
                          case .string(let val) = value else { return false }
                    switch op {
                        case .equals: return fieldStr == val
                        case .contains: return fieldStr.contains(val)
                        case .notContains: return !fieldStr.contains(val)
                        case .startsWith: return fieldStr.hasPrefix(val)
                        case .endsWith: return fieldStr.hasSuffix(val)
                        case .oIn: return val.contains(fieldStr)
                    }
                }
                return false
            case .group(let children):
                return children.first?.evaluate() ?? true
        }
    }
    
    // Print AST with evaluation results
    func printAST(indent: Int = 0) {
        let indentation = String(repeating: "  ", count: indent)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        switch self {
            case .empty:
                print("\(indentation)Empty (true)")
            case .logical(let op, let children):
                let result = evaluate()
                print("\(indentation)Logical (\(op)) -> \(result)")
                for child in children {
                    child.printAST(indent: indent + 1)
                }
            case .comparison(let element):
                let result = evaluate()
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
                        /*case .double:
                            if let doubleVal = rawFieldValue as? Double {
                                print("\(indentation)  Field Value: \(doubleVal)")
                            }
                        case .date:
                            if let dateVal = rawFieldValue as? Date {
                                print("\(indentation)  Field Value: \(dateFormatter.string(from: dateVal))")
                            }*/
                        default:
                            print("\(indentation)  Field Value: unknown")
                    }
                }
            case .group(let children):
                let result = evaluate()
                print("\(indentation)Group -> \(result)")
                for child in children {
                    child.printAST(indent: indent + 1)
                }
        }
    }
}
