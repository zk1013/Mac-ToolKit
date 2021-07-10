//
//  MainWindowController.swift
//  Test-Mac
//
//  Created by Archie You on 2021/7/11.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        if let appDelegate = NSApp.delegate as? AppDelegate {
            appDelegate.mainWindowController = self
        }
    }

}
