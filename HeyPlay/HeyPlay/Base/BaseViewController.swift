//
//  BaseViewController.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import UIKit
import SnapKit
import Combine

class BaseViewController: UIViewController {

    
    var tabBarItems : [TabBarItem] = [.home , .hot , .movie , .series , .menu]
    var bottomBGView : UIView?
    var stackView : UIStackView?
    var selectedTabItem : TabBarItem?
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setCurrentVC()
        setNavBar()
        setTabBarItem()
        setupUI()
        bindObserver()
    }
    
    func setCurrentVC() {
        ViewNavigation.shared.currentViewController = self
    }
    
    func setupUI() {
        
    }
    
    func bindObserver() {
        
    }
    
    func setupBottomBar() {
        if let bgView = bottomBGView {
            bgView.removeFromSuperview()
        }
        if let stkView = stackView {
            stkView.removeFromSuperview()
        }
        
        bottomBGView = UIView(frame: .zero)
        bottomBGView?.cornerRadius = 30
        bottomBGView?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomBGView!)
        self.bottomBGView?.bringSubviewToFront(self.view)
        
        bottomBGView?.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottomMargin.equalToSuperview().inset(10)
            make.height.equalTo(60)
        })
        
        bottomBGView?.backgroundColor = .darkGrey
        
        stackView = UIStackView()
        stackView?.backgroundColor = .clear
        stackView?.axis = .horizontal
        stackView?.distribution = .fillEqually
        stackView?.translatesAutoresizingMaskIntoConstraints = false
        bottomBGView?.addSubview(stackView!)
        
        stackView?.snp.makeConstraints({ make in
            make.leading.trailing.top.bottom.equalToSuperview().offset(0)
        })
        
        self.stackView?.bringSubviewToFront(self.view)
       
    }
    
    func setNavBar() {
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
    }
    
    func setTabBarItem() {
        if let _ = self.stackView {
            self.stackView?.arrangedSubviews.forEach({
                self.stackView?.removeArrangedSubview($0)
            })
        }
        tabBarItems.forEach { item in
            let tabBarView = CustomTabView(frame: .zero)
            
            tabBarView.imgView.image = item == self.selectedTabItem ? item.getActiveImage() : item.getInactiveImage()
            tabBarView.lblTitle.text = item.getTitle()
            tabBarView.btnAction.tag = item.rawValue
            tabBarView.onTapAction = { item in
                self.selectedTabItem = item
                self.updateItem()
            }
            
            stackView?.addArrangedSubview(tabBarView)
        }
        
        stackView?.layoutIfNeeded()
    }
    
    func updateItem() {
        if let _ = self.stackView {
            self.stackView?.removeFromSuperview()
        }
        
        if let _ = self.bottomBGView {
            self.bottomBGView?.removeFromSuperview()
        }
        
        updateView()
        setupBottomBar()
        setTabBarItem()
        
    }
    
    func updateView() {
        if let item = self.selectedTabItem {
            switch item {
            case .home:
                self.showHomeVc()
            case .hot:
                self.showHotVc()
            case .movie:
                self.showMovieSeriesVc(with: .movie)
            case .series:
                self.showMovieSeriesVc(with: .series)
            case .menu:
                self.showMenuVC(color: .red)
            }
        }
       
    }
    
    func showHomeVc() {
        if let delegate = self.delegate {
            let initialViewController = HomeViewController()
            let nav = UINavigationController(rootViewController: initialViewController)
            delegate.window?.rootViewController = nav
            delegate.window?.makeKeyAndVisible()
        }
    }
    
    func showHotVc() {
        if let delegate = self.delegate {
            let initialViewController = HotViewController()
            let nav = UINavigationController(rootViewController: initialViewController)
            nav.isNavigationBarHidden = false
            delegate.window?.rootViewController = nav
            delegate.window?.makeKeyAndVisible()
        }
    }
    
    func showMovieSeriesVc(with type : MovieSeriesType) {
        if let delegate = self.delegate {
            let initialViewController = ViewPagerViewController()
            initialViewController.movieSeriesType = type
//            initialViewController.movieSeriesType = type
            let nav = UINavigationController(rootViewController: initialViewController)
            nav.isNavigationBarHidden = false
            delegate.window?.rootViewController = nav
            delegate.window?.makeKeyAndVisible()
        }
    }
    
    
    func showMenuVC(color : UIColor ){
        if let delegate = self.delegate {
            let initialViewController = ViewController()
            initialViewController.view.backgroundColor = color
            let nav = UINavigationController(rootViewController: initialViewController)
            nav.isNavigationBarHidden = false
            delegate.window?.isHidden = false
            delegate.window?.rootViewController = nav
            delegate.window?.makeKeyAndVisible()
        }
    }


}
