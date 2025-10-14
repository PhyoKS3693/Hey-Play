//
//  Enums.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import Foundation
import UIKit

enum TabBarItem : Int{
    case home = 0
    case hot = 1
    case movie = 2
    case series = 3
    case menu = 4
    
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


enum HotActionType {
    case favorite
    case addToWatchlist
    
    func getInactiveImage() -> UIImage {
        switch self {
        case .favorite:
            return UIImage(named: "ic-heart-inactive")!
        case .addToWatchlist:
            return UIImage(named: "ic-addToWatch-inactive")!
        }
    }
    
    func getActiveImage() -> UIImage {
        switch self {
        case .favorite:
            return UIImage(named: "ic-heart-inactive")!
        case .addToWatchlist:
            return UIImage(named: "ic-addToWatch-inactive")!
        }
    }
}

enum MovieSeriesType {
    case movie
    case series
    
    func getTitle() -> String {
        switch self {
        case .movie:
            return "Movies"
        case .series:
            return "Series"
        }
    }
}

enum SeriesType : Int{
    case local = 0
    case international = 1
    
    func getTitle() -> String {
        switch self {
        case .local:
            return "Local"
        case .international:
            return "International"
        }
    }
}
