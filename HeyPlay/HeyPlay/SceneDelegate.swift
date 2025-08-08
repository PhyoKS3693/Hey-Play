//
//  SceneDelegate.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 08/08/2025.
//

import Foundation
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // Create a new appearance object
        let appearance = UINavigationBarAppearance()
        
        // Set the background color to black
        appearance.backgroundColor = .black
        
        // Set the title text color (optional, but good practice for a dark bar)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Apply this appearance to both standard and scroll edge states
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // To prevent the back button from being transparent on pushed view controllers,
        // you might also need to set the appearance for the back button item
        UINavigationBar.appearance().compactAppearance = appearance
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Create a new window for the scene
        let window = UIWindow(windowScene: windowScene)
        
        // Instantiate your storyboard (e.g., "Main")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Get the initial view controller from the storyboard
        let initialViewController = storyboard.instantiateViewController(withIdentifier: String(describing: HomeViewControllerViewController.self)) as? HomeViewControllerViewController
        
        // Set the root view controller and make the window visible
        let nav = UINavigationController(rootViewController: initialViewController!)
        nav.isNavigationBarHidden = false
        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
    }
}
