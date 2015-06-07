//
//  MOAttribute.swift
//  SwiftGenerator
//
//  Created by Fritz Anderson on 6/7/15.
//  Copyright (c) 2015 Fritz Anderson. All rights reserved.
//

import Foundation

enum AttributeType {
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
    func swiftType(optional: Bool = false) -> String {
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
        if optional { retval += "?" } else { retval += "!" }
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

class MOAttribute {
    let name: String
    let kind: AttributeType
    let optional: Bool
    
    //         <attribute name="whenPlayed" optional="YES" attributeType="Date" syncable="YES"/>

    init?(element: NSXMLElement) {
        if let name = element.attributeForName("name")?.stringValue,
            kind = element.attributeForName("attributeType")?.stringValue
        {
            self.name = name
            self.kind = AttributeType.fromAttributeTypeString(kind)
            if let optAttribute = element.attributeForName("optional")
                where optAttribute == "YES"
            { self.optional = true }
            else { self.optional = false }
        }
        else {
            self.name = ""
            self.kind = AttributeType.UnknownAttr("")
            self.optional = false
            return nil
        }
    }
    
    var declaration: String {
        return "@NSManaged var \(name): \(kind.swiftType(optional: self.optional))"
    }
}


