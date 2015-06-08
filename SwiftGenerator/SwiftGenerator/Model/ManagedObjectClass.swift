//
//  ManagedObjectClass.swift
//  SwiftGenerator
//
//  Created by Fritz Anderson on 6/7/15.
//  Copyright (c) 2015 Fritz Anderson. All rights reserved.
//

import Foundation

class ManagedObjectClass {
    static var managedObjectClasses: [String:ManagedObjectClass] = [:]
    
    
    let name: String
    let representedClass: String
    var attributes: [MOAttribute]
    var relationships: [ManagedObjectClass]
    
    init?(element: NSXMLElement) {
        var failed: Bool = false
        
        if let nameAttribute = element.attributeForName("name")?.stringValue {
            self.name = nameAttribute
        }
        else { self.name = "?"; failed = true }
        
        if let classAttribute = element.attributeForName("representedClassName")?.stringValue {
            self.representedClass = classAttribute
        }
        else { self.representedClass = "?"; failed = true }
        
        attributes = []
        for attrElement in element.elementsForName("attribute") {
            if let attribute = MOAttribute(element: attrElement as! NSXMLElement) {
                attributes.append(attribute)
            }
        }
        
        relationships = []
        for relElement in element.elementsForName("relationship") {
            
        }
        
        if failed { return nil }
        
        ManagedObjectClass.managedObjectClasses[name] = self
    }
    
    var declaration: String {
        var retval = "class _\(name) {\n" +
                    "\t// MARK: - Attributes\n" +
                    "%%%attributes%%%\n" +
                    "\t// MARK: - Relationships:\n" +
                    "%%%relationships%%%\n" +
                    "}\n"
        var attributeSection = ""
        for attribute in attributes {
            attributeSection += "\t" + attribute.declaration + "\n"
        }
        if let range = retval.rangeOfString("%%%attributes%%%") {
            retval.replaceRange(range, with: attributeSection)
        }
        
        var relationSection = ""
        for relationship in relationships {
            relationSection += "\t" + "\n"
        }
        if let range = retval.rangeOfString("%%%relationships%%%") {
            retval.replaceRange(range, with: relationSection)
        }
        
        return retval
    }
}

