//
//  ViewController.swift
//  QuickLayoutMacOSDemo
//
//  Created by Daniel Huri on 5/12/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Cocoa
import AppKit
import QuickLayout

class ViewController: NSViewController {

    private let view1 = QLView()
    private let view2 = QLView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(view1)
        view1.wantsLayer = true
        view1.layer?.backgroundColor = NSColor.blue.cgColor
        view1.layoutToSuperview(.left, .centerY)
        view1.set(.height, of: 100)
        view1.layout(.right, to: .centerX, of: view)
        
        view.addSubview(view2)
        view2.wantsLayer = true
        view2.layer?.backgroundColor = NSColor.red.cgColor
        view2.layoutToSuperview(.right, .centerY)
        view2.set(.height, of: 100)
        view2.layout(.left, to: .centerX, of: view)
    }
}
