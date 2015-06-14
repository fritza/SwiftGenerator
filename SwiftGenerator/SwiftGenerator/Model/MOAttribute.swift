//
//  MOAttribute.swift
//  SwiftGenerator
//
//  Created by Fritz Anderson on 6/7/15.
//  Copyright (c) 2015 Fritz Anderson. All rights reserved.
//

import Foundation

enum Optionality {
    case Optional
    case Defaulted
    case Neither
    case Both
}

enum AttributeType: Equatable {
    case IntegerAttr(Int)
    case StringAttr
    case FloatAttr
    case DoubleAttr
    case DateAttr
    case UnknownAttr(String)
    
    /// Returns the Swift type declaration for the attribute type.
    ///
    /// :param: optional Whether to append "?" instead of "!". Default `false`.
    /// :returns: A string suitable for use as a Swift type.
    func swiftType(#optionality: Optionality) -> String {
        var retval = ""
        switch self {
        case let .IntegerAttr(precision):
            retval = "Int\(precision)"
        case .StringAttr:
            retval = "String"
        case .FloatAttr:
            retval = "Float"
        case .DoubleAttr:
            retval = "Double"
        case .DateAttr:
            retval = "NSDate"
        case let .UnknownAttr(str):
            retval = str
        }
        switch optionality {
        case .Optional: retval += "?"
            //  Explicitly optional, and not initially set. Starts nil.
        case .Defaulted: retval += "!"
            //  Explicitly required, and has a default value. It’s illegal to save it as nil, but could pass through that state before saving.
        case .Both: retval += "?"
            //  Explicitly optional, but starts with a value. Because optionality is an open feature, should be taken as likely nil, even if not initially so.
        case .Neither: retval += "!"
            //  Explicitly required, so it ought to be assumed non-nil. But not defaulted, so it could be nil.
        }
        return retval
    }
    
    /// Classifies the attribute type reported by the data model.
    ///
    /// :param: str The `attributeType` attribute of an `<attribute/>` element.
    /// :returns: An `AttributeType` corresponding to the data-model type.
    static func fromAttributeTypeString(str: String) -> AttributeType {
        let components = str.componentsSeparatedByString(" ")
        switch components[0] {
        case "String":
            return StringAttr
        case "Integer":
            if let precision = components[1].toInt() {
                return IntegerAttr(precision)
            }
            else { return IntegerAttr(32) }
        case "Float":
            return FloatAttr
        case "Double":
            return DoubleAttr
        case "Date":
            return DateAttr
        default:
            return UnknownAttr(str)
        }
    }
}

func ==(lhs: AttributeType, rhs: AttributeType) -> Bool {
    switch lhs {
    case .StringAttr:
        switch rhs {
        case .StringAttr: return true
        default: return false
        }
        
    case .FloatAttr:
        switch rhs {
        case .FloatAttr: return true
        default: return false
        }
        
    case .DoubleAttr:
        switch rhs {
        case .DoubleAttr: return true
        default: return false
        }
        
    case .DateAttr:
        switch rhs {
        case .DateAttr: return true
        default: return false
        }
        
    case .IntegerAttr(let lhsPrecision):
        switch rhs {
        case .IntegerAttr(let rhsPrecision): return lhsPrecision == rhsPrecision
        default: return false
        }
        
    case .UnknownAttr(let lhsDesc):
        switch rhs {
        case .UnknownAttr(let rhsDesc): return lhsDesc == rhsDesc
        default: return false
        }
        
    default: return false
    }
}

struct MOAttribute: Equatable {
    let name: String
    let kind: AttributeType
    let optionality: Optionality

    // <attribute name="whenPlayed" optional="YES" attributeType="Date" syncable="YES"/>
    // <attribute name="longitude" optional="YES" attributeType="Float" defaultValueString="0.0" syncable="YES"/>


    init?(element: NSXMLElement) {
        if let name = element.attributeForName("name")?.stringValue,
            kind = element.attributeForName("attributeType")?.stringValue
        {
            self.name = name
            self.kind = AttributeType.fromAttributeTypeString(kind)
            let optional = element.booleanAttribute("optional")

            let defaulted: Bool
            if let defaultValue = element.stringForAttribute("defaultValueString") {
                defaulted = true
                // TODO: Maybe collect the known traits and comment the properties.
            }
            else { defaulted = false }

            if optional { self.optionality = .Optional }
            else if defaulted { self.optionality = .Defaulted }
            else { self.optionality = .Neither }
        }
        else {
            self.name = ""
            self.kind = AttributeType.UnknownAttr("")
            self.optionality = .Neither
            return nil
        }
    }
    
    var declaration: String {
        return "@NSManaged var \(name): \(kind.swiftType(optionality: self.optionality))"
    }
}

func ==(lhs: MOAttribute, rhs: MOAttribute) -> Bool {
    return lhs.name == rhs.name &&
        lhs.kind == rhs.kind &&
        lhs.optionality == rhs.optionality
}


