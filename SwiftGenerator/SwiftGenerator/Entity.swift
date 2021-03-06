//
//  Entity.swift
//  SwiftGenerator
//
//  Created by Fritz Anderson on 6/14/15.
//  Copyright (c) 2015 Fritz Anderson. All rights reserved.
//

import Foundation

struct Entity: Hashable {
    let name: String
    let attributes: Set<MOAttribute>
    let relationships: Set<MORelationship>
    
    init?(element: NSXMLElement) {
        if element.name != "entity" {
            name = "NONE"; attributes = []; relationships = []
            return nil
        }
        
        var failed = false
        
        if let attributeElements = element.elementsForName("element") as? [NSXMLElement],
            relationshipElements = element.elementsForName("relationship") as? [NSXMLElement]
        {
            name = element.stringForAttribute("name")!  //  I’m nervous about unwrapping
            var attrs = Set<MOAttribute>()
            for elem in attributeElements {
                if let att = MOAttribute(element: elem) {
                    attrs.insert(att)
                }
                else { failed = true; break }
            }
            
            var rels = Set<MORelationship>()
            for elem in relationshipElements {
                if let rel = MORelationship(source: name, element: elem) {
                    rels.insert(rel)
                }
                else { failed = true; break }
            }
            
            if failed {
                attributes = []; relationships = []; return nil
            }
            attributes = attrs
            relationships = rels
        }
        else {
            name = ""
            attributes = []
            relationships = []
            return nil
        }
    }
    
    var hashValue: Int {
        return name.hashValue ^ attributes.hashValue ^ relationships.hashValue
    }
}

func ==(lhs: Entity, rhs: Entity) -> Bool {
    return lhs.name == rhs.name &&
        lhs.attributes.exclusiveOr(rhs.attributes).count == 0 &&
        lhs.relationships.exclusiveOr(rhs.relationships).count == 0
}

