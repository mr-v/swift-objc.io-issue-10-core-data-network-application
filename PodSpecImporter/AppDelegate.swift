//
//  AppDelegate.swift
//  Pods
//
//  Created by Witold Skibniewski on 04/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if let inTests: AnyClass = NSClassFromString("XCTest") {
            return true
        }

        let appBuilder = AppBuilder()
        let storyboard:UIStoryboard = appBuilder.initializeStoryboard()
        let rootVC = storyboard.instantiateInitialViewController() as UIViewController
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = rootVC
        window!.makeKeyAndVisible()

        return true
    }

}


