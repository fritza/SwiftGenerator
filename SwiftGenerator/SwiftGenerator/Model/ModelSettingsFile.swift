//
//  ModelSettingsFile.swift
//  SwiftGenerator
//
//  Created by Fritz Anderson on 6/12/15.
//  Copyright (c) 2015 Fritz Anderson. All rights reserved.
//

import Foundation

enum PreferenceKeys: String {
    case SourceModel = "source model file"
    case DestinationDirectory = "destination directory"
    case MachineFilePrefix = "machine prefix"
    case MachineFileSuffix = "machine suffix"
    case HumanFilePrefix = "human prefix"
    case HumanFileSuffix = "human suffix"
}

/**
Preference file persisting generation traits.

Examples: placement of generated files, name prefixes and suffixes, and whatever else occurs to me.
*/

struct ModelSettingsFile {

}

