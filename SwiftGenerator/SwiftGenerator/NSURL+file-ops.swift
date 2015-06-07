//
//  NSURL+file-ops.swift
//  SwiftGenerator
//
//  Created by Fritz Anderson on 6/7/15.
//  Copyright (c) 2015 Fritz Anderson. All rights reserved.
//

import CoreFoundation
import Foundation

/**
Classifies a filesystem URL/path by type (file, directory, etc.)

:Bug: The `.SymLink` case reports the path and URL of the link and not its destination.
*/
public
enum KindOfFile {
    
    case File(String, NSURL)        // File (path, original URL)
    case Directory(String, NSURL)   // Directory (path, original URL)
    case SymLink(String, NSURL)     // Symbolic link (path, original URL)
                                    // (see Bug in enum documentation)
    case Nothing                    // No filesystem entity at the URL
    case Other(String)              // Pipe, device, etc. NOT USED.
    
    /**
     `KindOfFile` corresponding to a URL.
    
     :param: url The URL for the filesystem object to characterize
     :returns: a case of `KindOfFile`. NB that `.Other` is never returned.
    */
    static func fromURL(url: NSURL) -> KindOfFile {
        var error: NSError?
        var resourceType: AnyObject?
        if url.getResourceValue(
            &resourceType,
            forKey: NSURLFileResourceTypeKey,
            error: &error),
            let resourceType = resourceType as? String
        {
            switch resourceType {
            case NSURLFileResourceTypeRegular:
                //  TODO: Collect the file name (or the path?)
                return .File(url.path!, url)
            case NSURLFileResourceTypeDirectory:
                return .Directory(url.path!, url)
            case NSURLFileResourceTypeSymbolicLink:
                //  FIXME: Should instead recurse down the symlink tree, taking care to watch for loops.
                return .SymLink(url.path!, url)
            default:
                return .Nothing
            }
        }
        else {
            return .Nothing
        }
    }
    
    /**
    `KindOfFile` corresponding to a path.
    
    Implemented in terms of `fromURL(_)`.
    
    :param: path The path to the filesystem object to characterize
    :returns: a case of `KindOfFile`. NB that `.Other` is never returned.
    */
    static func fromPath(path: String) -> KindOfFile {
        if let url = NSURL(fileURLWithPath: path) {
            return KindOfFile.fromURL(url)
        }
        else {
            return .Nothing
        }
    }
}


