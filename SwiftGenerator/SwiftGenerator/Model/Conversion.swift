//
//  Conversion.swift
//  SwiftGenerator
//
//  Created by Fritz Anderson on 6/7/15.
//  Copyright (c) 2015 Fritz Anderson. All rights reserved.
//

import Foundation

/**
Engine for converting an Xcode data model to managed object source.

This class abstracts the source `xcdatamodel` and destination directory. `convert()` does the conversion.
*/


class Conversion {
    var dataModelURL: NSURL? {
        didSet {
            if dataModelURL != nil && destinationDirectoryURL != nil
            { okToCreate = true }
            else { okToCreate = false }
        }
    }
    
    var destinationDirectoryURL: NSURL? {
        didSet {
            if dataModelURL != nil && destinationDirectoryURL != nil
            { okToCreate = true }
            else { okToCreate = false }
        }
    }
    
    var okToCreate: Bool = false
    
    init(modelURL: NSURL?, destination: NSURL?) {
        dataModelURL = modelURL
        destinationDirectoryURL = destination
    }
    
    convenience init(modelPath: String, destinationPath: String) {
        let sourceURL = NSURL(fileURLWithPath: modelPath)
        let destURL = NSURL(fileURLWithPath: destinationPath)
        self.init(modelURL: sourceURL, destination: destURL)
    }
    
    func createDestinationIfNeeded() -> Bool {
        if !okToCreate { return false }
        
        var error: NSError?
        let fm = NSFileManager.defaultManager()
        
        switch KindOfFile.fromURL(destinationDirectoryURL!) {
        case .File:
            // There’s a file there. Worst case.
            return false
        
        case .Directory:
            //  There’s a directory; presume it’s OK.
            return true

        case let .Nothing:
            //  Nothing’s there. Try to create the directory.
            let success = fm.createDirectoryAtURL(destinationDirectoryURL!,
                withIntermediateDirectories: true,
                attributes: nil, error: &error)
            return success

        case let .SymLink(type):
            //  FIXME: See KindOfFile+fromURL(_) for inadequate traversal of symlinks.
            return false
        
        default:
            return false
        }
    }
    
    
}

