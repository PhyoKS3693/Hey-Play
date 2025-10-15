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
//            let controller = HomeViewController()
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyBoard.instantiateViewController(identifier: String(describing: SplashViewController.self)) as? SplashViewController else {return false}
            let navVC = UINavigationController(rootViewController: controller)
            navVC.navigationBar.isHidden = false
            window.rootViewController = navVC
            window.makeKeyAndVisible()
        }
        return true
    }



}

