//
//  ViewController.swift
//  macTest
//
//  Created by yarshure on 2017/12/13.
//  Copyright © 2017年 yarshure. All rights reserved.
//

import Cocoa
import XRuler
class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        XRuler.groupIdentifier = "745WQDK4L7.com.yarshure.Surf"
        _ = ProxyGroupSettings.share.proxys
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}
