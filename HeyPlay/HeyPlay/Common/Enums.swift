//
//  Enums.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import Foundation
import UIKit

enum TabBarItem {
    case home
    case hot
    case movie
    case series
    case menu
    
    func getTitle() -> String {
        switch self {
        case .home:
            return "Home"
        case .hot:
            return "Hot"
        case .movie:
            return "Movie"
        case .series:
            return "Series"
        case .menu:
            return "Menu"
        }
    }
    
    func getInactiveImage() -> UIImage {
        switch self {
        case .home:
            return UIImage(named: "ic-home-inactive")!
        case .hot:
            return UIImage(named: "ic-hot-inactive")!
        case .movie:
            return UIImage(named: "ic-movie-inactive")!
        case .series:
            return UIImage(named: "ic-series-inactive")!
        case .menu:
            return UIImage(named: "ic-menu-inactive")!
        }
    }
    
    func getActiveImage() -> UIImage {
        switch self {
        case .home:
            return UIImage(named: "ic-home-active")!
        case .hot:
            return UIImage(named: "ic-hot-active")!
        case .movie:
            return UIImage(named: "ic-movie-active")!
        case .series:
            return UIImage(named: "ic-series-active")!
        case .menu:
            return UIImage(named: "ic-menu-active")!
        }
    }
}

enum HomeSection : Int{
    case user = 0
    case banner = 1
    case recent = 2
    case movie = 3
    case series = 4
}
