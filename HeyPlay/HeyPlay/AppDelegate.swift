//
//  AppDelegate.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import UIKit
import GoogleSignIn
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // Orientation lock property
    static var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if let window = self.window {
            let controller = HomeViewController()
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyBoard.instantiateViewController(identifier: String(describing: SplashViewController.self)) as? SplashViewController else {return false}
            let navVC = UINavigationController(rootViewController: controller)
            navVC.navigationBar.isHidden = false
            window.rootViewController = navVC
            window.makeKeyAndVisible()
            
            //            let initialViewController = HomeViewController()
            //            let nav = UINavigationController(rootViewController: initialViewController)
            //            self.window?.rootViewController = nav
            //            self.window?.makeKeyAndVisible()
            
        }
        FirebaseApp.configure()
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }

    // MARK: - URL Handling for Google Sign-In
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

}

