//
//  DataModelFile.swift
//  SwiftGenerator
//
//  Created by Fritz Anderson on 6/14/15.
//  Copyright (c) 2015 Fritz Anderson. All rights reserved.
//

import Foundation

struct DataModelFile {
    let fileURL: NSURL
    var entities: [ManagedObjectClass] = []
    
    init?(url: NSURL) {
        if let url = DataModelFile.modelFileFromModelPackage(url) {
            fileURL = url
        }
        else {
            fileURL = NSURL(fileURLWithPath: "/", isDirectory: true)!
            return nil
        }
    }
    
    func fillEntities() -> Bool {
        var error: NSError?
        if let document = NSXMLDocument(contentsOfURL: fileURL, options: 0, error: &error),
            modelElement = document.rootElement()
            where modelElement.name! == "model"
        {
            let entities = modelElement.elementsForName("entity") as! [NSXMLElement]
            for entity in entities {
                
            }
            
            return true
        }
        return false
    }
    
    static func modelFileFromModelPackage(url: NSURL) -> NSURL? {
        if url.filePathURL == nil { return nil }

        if let components = url.pathComponents as? [String]
            where components.count >= 2
        {
            var error: NSError?
            let fm = NSFileManager()
            
            //  It’s the contents file of an .xcdatemodel package
            //  return unchanged.
            if components.last! == "contents" && components[components.count - 2].hasSuffix(".xcdatamodel") {
                return url
            }
            
            if url.pathExtension == "xcdatamodel" {
                return DataModelFile.modelFileFromModelPackage(url.URLByAppendingPathComponent("contents"))
            }
            
            if url.pathExtension == "xcdatamodleld",
                let packageName = url.lastPathComponent?.stringByDeletingPathExtension
            {
                //  FIXME: This is NOT going to find the right file in a versioned xcdatamodeld
                return DataModelFile.modelFileFromModelPackage(url.URLByAppendingPathComponent(packageName + ".xcdatamodel"))
            }
        }
        
        return nil
    }
}

// /Users/fritza/Dropbox/Swift/Beeswax/16-Measurement/Passer Rating/Passer_Rating.xcdatamodeld/Passer_Rating.xcdatamodel/contents

