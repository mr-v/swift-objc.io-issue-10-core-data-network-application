//
//  AppDelegate.swift
//  Pods
//
//  Created by Witold Skibniewski on 04/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let inTests = NSClassFromString("XCTest") != nil
        if inTests {
            return true
        }

        var possibleError: NSError?
        let documentsDirectory = NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: &possibleError)
        if let error = possibleError {
            println(error)
            abort()
        }

        let storeURL = documentsDirectory!.URLByAppendingPathComponent("db.sqlite")
        let modelURL = NSBundle.mainBundle().URLForResource("PodSpecModel", withExtension: "momd")!
        let persistenceStack = PersistenceStack(modelURL: modelURL, storeURL: storeURL)

        let importer = Importer(context: persistenceStack.backgroundContext)

        UpdatePodsUseCase(importer: importer).execute()

        return true
    }

}

