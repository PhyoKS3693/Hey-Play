//
//  ContentDetail.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Content Detail
struct ContentDetail: Decodable, Identifiable, Equatable {
    let id: Int
    let title: String?
    let description: String?
    let categoryDisplayText: String?
    let image: String?
    let releaseDate: String?
    let duration: String?
    let isFavourite: Bool?
    let watchLaterId: Int?
    let subscriptionType: Int?
    let subscriptionTypeDesc: String?
    let playable: Bool?
    let streamingUrl: String?
    let seasonList: [Season]?
    let recommendMovies: [Movie]?
    let movieArtistList: [MovieArtist]?
    let episodes: [Episode]?
    let detailImage: String?
    let landscapseImage: String?
    let movieType: Int?
    let movieTypeDesc: String?
    let trailerUrl: String?
    let adsSetting: AdsSetting?
    let shareUrl: String?

    // MARK: - Safe Accessors
    var safeTitle: String { title ?? "" }
    var safeDescription: String { description ?? "" }
    var safeCategoryDisplayText: String { categoryDisplayText ?? "" }
    var safeImage: String { image ?? "" }
    var safeReleaseDate: String { releaseDate ?? "" }
    var safeDuration: String { duration ?? "" }
    var safeSeasonList: [Season] { seasonList ?? [] }
    var safeRecommendMovies: [Movie] { recommendMovies ?? [] }
    var safeMovieArtistList: [MovieArtist] { movieArtistList ?? [] }
    var safeEpisodes: [Episode] { episodes ?? [] }

    // MARK: - Computed Properties
    var isInWatchLater: Bool {
        return (watchLaterId ?? -1) != -1
    }

    var isFree: Bool {
        return (subscriptionType ?? 1) == 1
    }

    var isVIP: Bool {
        return (subscriptionType ?? 1) == 2
    }

    var isPlayable: Bool {
        return playable ?? false
    }

    var safeStreamingUrl: String {
        return streamingUrl ?? ""
    }

    var safeTrailerUrl: String {
        return trailerUrl ?? ""
    }

    var hasTrailer: Bool {
        guard let trailer = trailerUrl, !trailer.isEmpty else { return false }
        return true
    }

    var safeDetailImage: String {
        return detailImage ?? ""
    }

    var safeLandscapeImage: String {
        return landscapseImage ?? ""
    }

    var safeShareUrl: String {
        return shareUrl ?? ""
    }
}

// MARK: - Movie Artist
struct MovieArtist: Decodable, Identifiable, Equatable {
    let movieId: Int?
    let artistId: Int?
    let artistType: Int?
    let artistTypeDesc: String?
    let name: String?
    let gender: Int?
    let genderDesc: String?
    let imagePath: String?

    // ID for Identifiable protocol
    var id: Int { artistId ?? 0 }

    // Backward compatibility
    var image: String? { imagePath }
    var role: String? { artistTypeDesc }
}

// MARK: - Episode
struct Episode: Decodable, Identifiable, Equatable {
    let episodeId: Int?
    let name: String?
    let description: String?
    let streamingUrl: String?
    let subscriptionType: Int?
    let subscriptionTypeDesc: String?
    let playable: Bool?
    let playerType: Int?
    let detailImage: String?
    let landscapseImage: String?

    // ID for Identifiable protocol
    var id: Int { episodeId ?? 0 }

    // Backward compatibility
    var episodeName: String { name ?? "" }
    var duration: String? { nil } // Not in current API response
    var thumbnail: String? { detailImage } // Use detailImage as thumbnail

    // Computed properties
    var isPlayable: Bool { playable ?? false }
    var safeStreamingUrl: String { streamingUrl ?? "" }
    var safeDetailImage: String { detailImage ?? "" }
    var safeLandscapeImage: String { landscapseImage ?? "" }
    var safeDescription: String { description ?? "" }
}

// MARK: - Season
struct Season: Decodable, Identifiable, Equatable {
    let seasonId: Int?
    let movieId: Int?
    let seasonNo: Int?
    let seasonDisplayText: String?

    // ID for Identifiable protocol
    var id: Int { seasonId ?? 0 }

    // Backward compatibility
    var seasonNumber: Int? { seasonNo }
    var seasonName: String? { seasonDisplayText }

    // Safe accessors
    var safeSeasonName: String { seasonDisplayText ?? "" }
    var safeSeasonNumber: Int { seasonNo ?? 0 }
}

// MARK: - Type Alias for API Response
typealias ContentDetailResponse = BaseAPIResponse<ContentDetail>
