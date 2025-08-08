//
//  BaseViewController.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {

    
    var tabBarItems : [TabBarItem] = [.home , .hot , .movie , .series , .menu]
    var bottomBGView : UIView?
    var stackView : UIStackView?
    var selectedTabItem : TabBarItem = .home
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBottomBar()
        setTabBarItem()
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
            make.bottomMargin.equalToSuperview().inset(25)
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
            
            stackView?.addArrangedSubview(tabBarView)
        }
    }

}
