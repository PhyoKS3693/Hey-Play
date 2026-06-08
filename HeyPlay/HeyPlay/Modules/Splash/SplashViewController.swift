//
//  SplashViewController.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 14/10/2025.
//

import UIKit
import Combine

class SplashViewController: BaseViewController {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    
    var countdownTime = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bindObserver() {
        super.bindObserver()
        setupTimer()
        
        lblMessage.text = "splashTitle".localized()
        lblMessage.font = FontUtility.largeTitle()
        lblMessage.textColor = .white
    }
    
    func setupTimer() {
        Timer.publish(
            every: 1.0,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { _ in
            self.countdownTime -= 1
            if self.countdownTime == 0 {
                self.navigateBasedOnSession()
            }
        }
        .store(in: &cancellables)
    }

    private func navigateBasedOnSession() {
        // Check if user is logged in
        if AppDefaultsManager.shared.isLoggedIn {
            // User is logged in → Go to Home
            ViewNavigation.shared.showMainTabBar()
        } else {
            // User is not logged in → Go to Login
            ViewNavigation.shared.showLoginView()
        }
    }
    

}
