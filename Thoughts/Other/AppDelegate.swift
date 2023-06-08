//
//  AppDelegate.swift
//  Thoughts
//
//  Created by Nazar Kopeyka on 14.04.2023.
//

import Purchases /* 232 */
import Firebase /* 29 */
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure() /* 30 */
        
        Purchases.configure(withAPIKey: "appl_sKFVXGUXUGWfQEVraPzrDjNvhrg") /* 233 */
        
        IAPManager.shared.getSubscriptionStatus(completion: nil) /* 280 as soon as the app launches, want to get the latest status from the revenueCat */
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

