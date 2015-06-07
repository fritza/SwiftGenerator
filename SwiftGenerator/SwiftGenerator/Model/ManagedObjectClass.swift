//
//  ManagedObjectClass.swift
//  SwiftGenerator
//
//  Created by Fritz Anderson on 6/7/15.
//  Copyright (c) 2015 Fritz Anderson. All rights reserved.
//

import Foundation

class ManagedObjectClass {
    let name: String
    var attributes: [String]
    var relationships: [ManagedObjectClass]
    
    init(name: String) {
        self.name = name
        attributes = []
        relationships = []
    }
}

