//
//  PlayerView.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 12/17/25.
//

import SwiftUI
import AVKit
import AVFoundation

struct PlayerView: UIViewControllerRepresentable {
    let videoURL: String
    @ObservedObject var viewModel: VideoPlayerViewModel

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        print("🎬 [PlayerView] Creating player with URL: \(videoURL)")

        guard let url = URL(string: videoURL) else {
            print("❌ [PlayerView] Invalid URL: \(videoURL)")
            return AVPlayerViewController()
        }

        let player = AVPlayer(url: url)
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = true

        // Store player in context for time tracking
        context.coordinator.player = player
        context.coordinator.startTimeTracking()

        // Automatically start playing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            player.play()
            print("▶️ [PlayerView] Starting playback")
        }

        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Update the player URL if it changed
        guard let url = URL(string: videoURL) else { return }

        if uiViewController.player?.currentItem?.asset as? AVURLAsset != AVURLAsset(url: url) {
            print("🔄 [PlayerView] Updating player URL")
            context.coordinator.stopTimeTracking()
            let newPlayer = AVPlayer(url: url)
            uiViewController.player = newPlayer
            context.coordinator.player = newPlayer
            context.coordinator.startTimeTracking()
            newPlayer.play()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    class Coordinator {
        var viewModel: VideoPlayerViewModel
        var player: AVPlayer?
        var timeObserver: Any?

        init(viewModel: VideoPlayerViewModel) {
            self.viewModel = viewModel
        }

        func startTimeTracking() {
            guard let player = player else { return }

            // Track playback time every 0.5 seconds
            let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
                guard let self = self else { return }
                let currentTime = CMTimeGetSeconds(time)
                let currentTimeMs = Int(currentTime * 1000) // Convert to milliseconds
                self.viewModel.updateCurrentTime(Double(currentTimeMs))
            }

            // Track duration
            if let duration = player.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                if durationSeconds.isFinite && durationSeconds > 0 {
                    let durationMs = Int(durationSeconds * 1000)
                    self.viewModel.updateDuration(Double(durationMs))
                }
            }
        }

        func stopTimeTracking() {
            if let observer = timeObserver, let player = player {
                player.removeTimeObserver(observer)
                timeObserver = nil
            }
        }

        deinit {
            stopTimeTracking()
        }
    }

    static func dismantleUIViewController(_ uiViewController: AVPlayerViewController, coordinator: Coordinator) {
        coordinator.stopTimeTracking()
    }
}
