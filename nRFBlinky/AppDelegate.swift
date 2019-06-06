//
//  AppDelegate.swift
//  nRFBlinky
//
//  Created by Mostafa Berg on 28/11/2017.
//  Copyright © 2017 Nordic Semiconductor ASA. All rights reserved.
//

import UIKit
import CoreBluetooth
import IQKeyboardManagerSwift
import Firebase
import FirebaseDatabase
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    public var centralManager: CBCentralManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        centralManager = CBCentralManager()
        
        IQKeyboardManager.shared.enable = true
        
        FirebaseApp.configure()
        logUser()
        Fabric.with([Crashlytics.self])
//
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func logUser() {
        // TODO: Use the current user's information
        // You can call any combination of these three methods
        Crashlytics.sharedInstance().setUserEmail("wbit85@gmail.com")
        Crashlytics.sharedInstance().setUserIdentifier("12345")
        Crashlytics.sharedInstance().setUserName("Test User")
    }

}
var counter = 0
public func getCurrentMillis() -> Int64 {
    return Int64(Date().timeIntervalSince1970 * 1000)
}
func firebaseLog(_ message:String) {
    let ref = Database.database().reference()
    ref.child(getMacAddress()).child("\(getCurrentMillis())_\(counter)").setValue( message)
    counter += 1
}

func getMacAddress() -> String {
    return UIDevice.current.identifierForVendor!.uuidString
}
