//
//  AppDelegate.swift
//  PushNotificationDemo
//
//  Created by tomas on 06/02/2020.
//  Copyright © 2020 Subito.it. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    var viewController: ViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController

        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
                
        UNUserNotificationCenter.current().delegate = self

        return true
    }
    
    // MARK: Push notifications
        
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Handle push from background or closed")
        
        let notificationContent = response.notification.request.content
        guard let customKey1 = notificationContent.userInfo["customKey1"] as? String,
              let customKey2 = notificationContent.userInfo["customKey2"] as? String else {
            return
        }
        
        let message = "\(notificationContent.body)\n\(customKey1)\n\(customKey2)"
        viewController?.presentAlert(title: notificationContent.title, message: message)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
    }
}
