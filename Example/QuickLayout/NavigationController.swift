//
//  NavigationController.swift
//  DemoApp
//
//  Created by Daniel Huri on 5/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        pushViewController(MainViewController(), animated: false)
    }
}
