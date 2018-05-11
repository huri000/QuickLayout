//
//  NavigationController.swift
//  DemoApp
//
//  Created by Daniel Huri on 5/11/18.
//  Copyright (c) 2018 huri000@gmail.com. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = QLColor.BlueGray.c700
        pushViewController(MainViewController(), animated: false)
    }
}
