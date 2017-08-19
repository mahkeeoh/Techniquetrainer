//
//  AppDelegate.swift
//  TechTrainer
//
//  Created by Mikael Olezeski on 7/9/17.
//  Copyright © 2017 Mikael Olezeski. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack(modelName: "TechTrainer")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        _ = coreDataStack.mainContext
        
        guard let viewController = window?.rootViewController as? TechniqueViewController else {
            fatalError("Application Storyboard mis-configuration")
        }
        
        viewController.coreDataStack = coreDataStack

        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
}
