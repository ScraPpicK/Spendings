//
//  AppDelegate.swift
//  Finances
//
//  Created by Vadym Patalakh on 1/6/19.
//  Copyright © 2019 Vadym Patalakh. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        MagicalRecord.setupCoreDataStack(withStoreNamed: "Finances")
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        MagicalRecord.cleanUp()
    }
}

