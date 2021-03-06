//
//  MORelationship.swift
//  SwiftGenerator
//
//  Created by Fritz Anderson on 6/7/15.
//  Copyright (c) 2015 Fritz Anderson. All rights reserved.
//

import Foundation

struct MORelationship: Equatable, Hashable {
    let relationName: String
    let sourceEntityName: String
    let optional: Bool
    let destEntityName: String
    let toMany: Bool

    init?(source: String, element: NSXMLElement) {
        var failed = false
        // <relationship name="games" optional="YES" toMany="YES"
        //  deletionRule="Cascade" destinationEntity="Game" inverseName="passer"
        //  inverseEntity="Game" syncable="YES"/>
        sourceEntityName = source

        if let name = element.stringForAttribute("name") {
            self.relationName = name
        }
        else { self.relationName = "?"; failed = true }

        optional = element.booleanAttribute("optional")

        toMany = element.booleanAttribute("optional")

        if let dest = element.stringForAttribute("destinationEntity"){
            destEntityName = dest
        }
        else { destEntityName = "?"; failed = true }

        if failed { return nil }
    }


    var declaration: String {
        var template = "@NSManaged var \(relationName): "
        if toMany {
            template += "Set<\(destEntityName)>"
            if optional { template += "?" }
            else { template += "!" }
        }
        else {
            template += destEntityName
            if optional { template += "?" }
            else { template += "!" }
        }
        return template
    }

    static let toManyAddTemplate =
        "func add%%%nameObject%%%(new: %%%destEntityName%%%) {\n" +
        "\tself.willChangeValueForKey(\"%%%name%%%\")" +
        "\tself.primitive%%%destEntityName%%%.addObject(new)\n" +
        "\tself.didChangeValueForKey(\"%%%name%%%\")\n"

    var relationshipAccessors: String? {
        if !toMany { return nil }



        return ""
    }

    
    var hashValue: Int {
        let relNameHash = relationName.hashValue
        let sourceHash = sourceEntityName.hashValue
        let optHash = optional.hashValue
        let destHash = destEntityName.hashValue
        let toManyHash = toMany.hashValue
        return relNameHash ^ sourceHash ^ optHash ^ destHash ^ toManyHash
    }
}

/*
let relationName: String
let sourceEntityName: String
let optional: Bool
let destEntityName: String
let toMany: Bool
*/

func ==(lhs: MORelationship, rhs: MORelationship) -> Bool {
    return lhs.relationName == rhs.relationName &&
        lhs.sourceEntityName == rhs.sourceEntityName &&
        lhs.optional == rhs.optional &&
        lhs.destEntityName == rhs.destEntityName &&
        lhs.toMany == rhs.toMany
}


