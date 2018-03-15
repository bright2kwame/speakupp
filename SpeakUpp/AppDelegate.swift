//
//  AppDelegate.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 22/01/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications
import IQKeyboardManagerSwift
import ZKDrawerController
import OneSignal


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,OSPermissionObserver, OSSubscriptionObserver  {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let color = UIColor.hex(hex: Key.primaryHomeHexCode)
        UINavigationBar.appearance().barTintColor = color
        application.statusBarStyle = .lightContent
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().tintColor = color
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
        //realm migration
        let config = Realm.Configuration(
            schemaVersion: 3,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                   
                }
        })
        
       
        Realm.Configuration.defaultConfiguration = config
        IQKeyboardManager.sharedManager().enable = true
        
        self.registerNotification()
        
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
            print("Received Notification: \(notification!.payload.notificationID)")
            print("launchURL = \(notification?.payload.launchURL ?? "None")")
            print("content_available = \(notification?.payload.contentAvailable ?? false)")
        }
        
        let user = User.getUser()
        if (user == nil){
           window?.rootViewController = WelcomeController()
        } else if (!(user?.isVerified)!){
             window?.rootViewController = VerificationCodeController()
        } else {
            
            let notification: [AnyHashable: Any]? = (launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable: Any])
            if notification == nil {
                
                let home = HomeController()
                let drawer = ViewControllerHelper.startHome(controller: home)
                
                window?.rootViewController = drawer
                home.homeDrawerController = drawer
            }
        }
        
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            // This block gets called when the user reacts to a notification received
            let payload: OSNotificationPayload? = result?.notification.payload
            print("Message = \(payload!.body)")
            print("badge number = \(payload?.badge ?? 0)")
            print("notification sound = \(payload?.sound ?? "None")")
        
            self.hadleNotificationClick()
            
        }
        
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: true,
                                     kOSSettingsKeyInAppLaunchURL: true]
        
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: Key.oneSignalKey,
                                        handleNotificationReceived: notificationReceivedBlock,
                                        handleNotificationAction: notificationOpenedBlock,
                                        settings: onesignalInitSettings)
       
        return true
    }
    
    // Add this new method
    func onOSPermissionChanged(_ stateChanges: OSPermissionStateChanges!) {
        // Example of detecting answering the permission prompt
        if stateChanges.from.status == OSNotificationPermission.notDetermined {
            if stateChanges.to.status == OSNotificationPermission.authorized {
                print("Thanks for accepting notifications!")
            } else if stateChanges.to.status == OSNotificationPermission.denied {
                print("Notifications not accepted. You can turn them on later under your iOS settings.")
            }
        }
    }
    
    
    func registerNotification()  {
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        // Add your AppDelegate as an obsserver
        OneSignal.add(self as OSPermissionObserver)
        OneSignal.add(self as OSSubscriptionObserver)
    }
    
    // Add this new method
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
            let _ = stateChanges.to.userId
            let user = User.getUser()
            if user == nil {
                return
            }
            ApiService().updateUserToken(completion: { (status) in
                
            })
        }
    }
    

    func hadleNotificationClick()  {
        let user = User.getUser()
        if user == nil {
            window?.rootViewController = WelcomeController()
        } else {
            let home = HomeController()
            let drawer = ViewControllerHelper.startHome(controller: home)
            
            self.window?.rootViewController = drawer
            home.homeDrawerController = drawer
        }
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

}

