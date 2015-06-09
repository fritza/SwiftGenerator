//
//  MORelationship.swift
//  SwiftGenerator
//
//  Created by Fritz Anderson on 6/7/15.
//  Copyright (c) 2015 Fritz Anderson. All rights reserved.
//

import Foundation

struct MORelationship {
    let name: String
    let sourceEntity: String
    let optional: Bool
    let destEntity: String
    let toMany: Bool
    
    init?(source: String, element: NSXMLElement) {
        var failed = false
        // <relationship name="games" optional="YES" toMany="YES" deletionRule="Cascade" destinationEntity="Game" inverseName="passer" inverseEntity="Game" syncable="YES"/>
        sourceEntity = source
        
        if let name = element.attributeForName("name")?.stringValue {
            self.name = name
        }
        else { self.name = "?"; failed = true }
        
        if let opt = element.attributeForName("optional")?.stringValue
            where opt == "YES"
        {
        optional = true
        }
        else { optional = false }
        
        if let many = element.attributeForName("optional")?.stringValue
        where many == "YES"
        {
            toMany = true
        }
        else { toMany = false }
        
        if let dest = element.attributeForName("destinationEntity")?.stringValue {
            destEntity = dest
        }
        else { destEntity = "?"; failed = true }
        
        if failed { return nil }
    }
    
    
}
