//
//  MORelationship.swift
//  SwiftGenerator
//
//  Created by Fritz Anderson on 6/8/15.
//  Copyright (c) 2015 Fritz Anderson. All rights reserved.
//

import Foundation

/// Abstraction of a `<relationship/>` tag in an .xcdatamodel.
///
/// Done on a branch because I’d started the class on another machine (`master`) and didn’t push it.

class MORelationship {
    let sourceEntityName: String
    let destEntityName: String
    let relationName: String
    let inverseRelationName: String
    let toMany: Bool
    let optional: Bool

    init?(element: NSXMLElement, sourceEntity: String) {
        var failed: Bool = false

        sourceEntityName = sourceEntity

        if let destName = element.stringForAttribute("destinationEntity") {
            destEntityName = destName
        }
        else { destEntityName = "?"; failed = true }

        if let relName = element.stringForAttribute("name") {
            relationName = relName
        }
        else { relationName = "?"; failed = true }

        inverseRelationName = element.stringForAttribute("inverseName") ?? "?"

        optional = element.booleanAttribute("optional")
        toMany = element.booleanAttribute("toMany")

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
}

