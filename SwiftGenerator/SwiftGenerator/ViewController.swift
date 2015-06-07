//
//  ViewController.swift
//  SwiftGenerator
//
//  Created by Fritz Anderson on 6/7/15.
//  Copyright (c) 2015 Fritz Anderson. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    
    @IBOutlet weak var sourceComboBox: NSComboBox!
    @IBOutlet weak var destComboBox: NSComboBox!
    @IBOutlet weak var conversionButton: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()


        // TODO: Reload the source and destination fields
        
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func clearComboBoxes() {
        for box in [sourceComboBox, destComboBox] {
            box.stringValue = ""
        }
    }
    
    func activateConvertButton() {
        let filled = [sourceComboBox, destComboBox].reduce(true) {
            $0 && $1.stringValue != ""
        }
        conversionButton.enabled = filled
    }


    @IBAction func performSourceSelect(sender: AnyObject) {
    }
    
    @IBAction func performDestSelect(sender: AnyObject) {
    }
    
    @IBAction func performConversion(sender: AnyObject) {
    }
    
}

