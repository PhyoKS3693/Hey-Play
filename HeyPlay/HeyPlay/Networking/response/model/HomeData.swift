//
//  HomeData.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Home Data
struct HomeData: Decodable {
    let activePlanTypeName: String?
    let expiredTime: String?
    let firebaseTopics: [String]?
    let playlists: [Playlist]?
    let lastWatchContentList: [Movie]?
    let bannerList: [Banner]?
    let adsSetting: AdsSetting?

    // Safe accessors
    var safeFirebaseTopics: [String] { firebaseTopics ?? [] }
    var safePlaylists: [Playlist] { playlists ?? [] }
    var safeLastWatchContentList: [Movie] { lastWatchContentList ?? [] }
    var safeBannerList: [Banner] { bannerList ?? [] }
}

// MARK: - Playlist
struct Playlist: Decodable, Identifiable {
    let playlistId: Int
    let title: String?
    let titleMM: String?
    let typeDesc: String?
    let viewAllVisible: Bool?
    let layout: Int?
    let layoutDesc: String?
    let movieList: [Movie]?
    let redirectScreenType: Int?
    let redirectScreenTypeDesc: String?

    var id: Int { playlistId }
    var safeTitle: String { title ?? "" }
    var safeTitleMM: String { titleMM ?? "" }
    var safeMovieList: [Movie] { movieList ?? [] }

    // MARK: - Layout Types
    /// Layout 1: Horizontal scrolling portrait cards (5 items visible)
    /// Layout 2: Horizontal scrolling landscape cards (2 rows visible)
    /// Layout 3: Vertical list with image left, title/episode right
    /// Layout 4: Vertical grid of portrait posters (3 columns)
    /// Layout 5: Horizontal scrolling large landscape cards (1 row)
    /// Layout 6: Vertical grid of portrait posters (2 columns)
    enum LayoutType: Int {
        case layout1 = 1
        case layout2 = 2
        case layout3 = 3
        case layout4 = 4
        case layout5 = 5
        case layout6 = 6

        var description: String {
            switch self {
            case .layout1: return "Layout 1"
            case .layout2: return "Layout 2"
            case .layout3: return "Layout 3"
            case .layout4: return "Layout 4"
            case .layout5: return "Layout 5"
            case .layout6: return "Layout 6"
            }
        }
    }

    // MARK: - Redirect Screen Types
    enum RedirectScreenType: Int {
        case movie = 1
        case series = 2
        case playlistDetail = 3

        var description: String {
            switch self {
            case .movie: return "Redirect to movie screen"
            case .series: return "Redirect to series screen"
            case .playlistDetail: return "Redirect to playlist detail"
            }
        }
    }

    // MARK: - Computed Properties
    var layoutType: LayoutType {
        return LayoutType(rawValue: layout ?? 1) ?? .layout1
    }

    var redirectType: RedirectScreenType {
        return RedirectScreenType(rawValue: redirectScreenType ?? 3) ?? .playlistDetail
    }
}

// MARK: - Banner
struct Banner: Decodable, Identifiable {
    let id: Int
    let title: String?
    let description: String?
    let imagePath: String?
    let bannerType: Int?
    let bannerTypeDescription: String?
    let sequenceNo: Int?
    let detailViewId: Int?
    let detailViewName: String?
    let streamingUrl: String?
    let webUrl: String?
    let webUrlOpenType: Int?
    let webUrlOpenTypeDesc: String?
    let packageList: [BannerPackage]?

    // MARK: - Banner Types
    enum BannerType: Int {
        case normal = 1
        case movies = 2
        case series = 3
        case subscription = 8
        case package1 = 9
        case package2 = 10
    }

    // MARK: - Web URL Open Types
    enum WebUrlOpenType: Int {
        case inApp = 1
        case external = 2
    }

    // MARK: - Computed Properties
    var type: BannerType? {
        guard let bannerType = bannerType else { return nil }
        return BannerType(rawValue: bannerType)
    }

    var openType: WebUrlOpenType {
        return WebUrlOpenType(rawValue: webUrlOpenType ?? 1) ?? .inApp
    }

    var hasWebUrl: Bool {
        return !(webUrl ?? "").isEmpty
    }

    var hasDetailView: Bool {
        return (detailViewId ?? 0) > 0
    }

    var fullImageURL: String {
        guard let imagePath = imagePath, !imagePath.isEmpty else { return "" }
        // Image URLs are already full URLs from API
        if imagePath.hasPrefix("http") {
            return imagePath
        }
        return imagePath
    }
}

// MARK: - Banner Package
struct BannerPackage: Decodable, Identifiable {
    let id: Int
    let name: String?
    let price: Double?
}

// MARK: - Ads Setting
struct AdsSetting: Decodable, Equatable {
    let id: Int?
    let title: String?
    let image: String?
    let link: String?
    let isCustomAds: Bool?
    let isAuthRequired: Bool?
    let isExternal: Bool?

    var safeTitle: String { title ?? "" }
    var safeLink: String { link ?? "" }
    var safeImage: String { image ?? "" }
}

// MARK: - Type Alias for API Response
typealias HomeDataResponse = BaseAPIResponse<HomeData>
