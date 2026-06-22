//
//  VideoPlayerViewModel.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 12/17/25.
//

import Foundation
import Combine
import UIKit
import AVFoundation

final class VideoPlayerViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var watchData: WatchData?
    @Published var streamingUrl: String? = nil
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0

    // MARK: - Properties
    var videoTitle: String = ""
    private var movieId: Int = 0
    private var episodeId: String?
    private var saveProgressTimer: Timer?

    // MARK: - Computed Properties
    var hasStreamingUrl: Bool {
        return !(streamingUrl ?? "").isEmpty
    }

    var progressPercentage: Double {
        guard duration > 0 else { return 0 }
        return (currentTime / duration) * 100
    }

    // MARK: - Init
    init(movieId: Int = 0, episodeId: String? = nil) {
        self.movieId = movieId
        self.episodeId = episodeId
    }

    deinit {
        print("♻️ [VideoPlayerViewModel] Deinit called - cleaning up")
        stopProgressTracking()
    }

    // MARK: - Set Movie Info
    func setMovieInfo(movieId: Int, episodeId: String? = nil) {
        self.movieId = movieId
        self.episodeId = episodeId
    }

    // MARK: - Fetch Streaming URL
    func fetchStreamingUrl() {
        guard movieId > 0 else {
            errorMessage = "Invalid movie ID"
            return
        }

        isLoading = true
        errorMessage = nil

        // Capture values to avoid retaining self
        let capturedMovieId = movieId
        let capturedEpisodeId = episodeId

        Task { @MainActor [weak self] in
            guard let self = self else { return }

            let result = await ContentService.shared.watchContent(
                movieId: capturedMovieId,
                episodeId: capturedEpisodeId
            )

            self.isLoading = false

            switch result {
            case .success(let data):
                self.watchData = data
                self.streamingUrl = data.streamingUrl
                self.currentTime = Double(data.lastWatchTimeStamps ?? 0)

                // Start tracking progress
                self.startProgressTracking()

            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Save Watch Progress
    func saveWatchProgress() {
        guard movieId > 0 else {
            print("⚠️ [VideoPlayerViewModel] Cannot save progress: movieId is 0")
            return
        }

        // currentTime is already in milliseconds
        let timestampString = String(Int(currentTime))

        print("💾 [VideoPlayerViewModel] Saving watch progress:")
        print("   MovieId: \(movieId)")
        print("   EpisodeId: \(episodeId ?? "nil")")
        print("   Timestamp: \(timestampString) ms (\(Int(currentTime/1000))s)")

        // Capture values to avoid retaining self
        let capturedMovieId = movieId
        let capturedEpisodeId = episodeId

        Task { [weak self] in
            let result = await LastWatchService.shared.addLastWatch(
                movieId: capturedMovieId,
                movieEpisodeId: capturedEpisodeId ?? "",
                lastWatchTimeStamps: timestampString
            )

            guard let _ = self else { return }

            switch result {
            case .success:
                print("✅ [VideoPlayerViewModel] Watch progress saved successfully")
            case .failure(let error):
                print("❌ [VideoPlayerViewModel] Error saving watch progress: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Progress Tracking
    private func startProgressTracking() {
        stopProgressTracking() // Stop any existing timer first

        // Save progress every 10 seconds
        saveProgressTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.saveWatchProgress()
        }
    }

    private func stopProgressTracking() {
        saveProgressTimer?.invalidate()
        saveProgressTimer = nil

        // Save final progress when stopping
        if currentTime > 0 {
            saveWatchProgress()
        }
    }

    // MARK: - Update Current Time
    func updateCurrentTime(_ time: Double) {
        self.currentTime = time
    }

    // MARK: - Update Duration
    func updateDuration(_ duration: Double) {
        self.duration = duration
    }

    // MARK: - Playback Controls
    func seekToTime(_ time: Double) {
        self.currentTime = time
        saveWatchProgress()
    }

    func onPlaybackEnded() {
        stopProgressTracking()
        saveWatchProgress()
    }

    func onPlayerPaused() {
        saveWatchProgress()
    }
}
