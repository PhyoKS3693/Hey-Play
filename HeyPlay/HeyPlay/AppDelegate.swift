//
//  AppDelegate.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if let window = self.window {
            let controller = HomeViewController()
            let navVC = UINavigationController(rootViewController: controller)
            navVC.navigationBar.isHidden = false
            window.rootViewController = navVC
            window.makeKeyAndVisible()
        }
        
        
        return true
    }



}

