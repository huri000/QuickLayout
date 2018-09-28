//
//  AppDelegate.swift
//  QuickLayout
//
//  Created by huri000@gmail.com on 11/19/2017.
//  Copyright (c) 2017 huri000@gmail.com. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = NavigationController()
        window!.makeKeyAndVisible()
        return true
    }
}
