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

        // Create player item with better configuration
        let asset = AVURLAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)

        let player = AVPlayer(playerItem: playerItem)
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = true
        controller.allowsPictureInPicturePlayback = true

        // Configure player for better performance
        player.allowsExternalPlayback = true
        player.automaticallyWaitsToMinimizeStalling = true

        // Store player in context for time tracking
        context.coordinator.player = player
        context.coordinator.startTimeTracking()

        // Observe player status
        context.coordinator.observePlayerStatus(playerItem: playerItem)

        // Automatically start playing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            print("▶️ [PlayerView] Starting playback")
            player.play()
        }

        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Only update if the URL actually changed
        guard let url = URL(string: videoURL) else { return }

        if let currentAsset = uiViewController.player?.currentItem?.asset as? AVURLAsset,
           currentAsset.url == url {
            // Same URL, don't update
            return
        }

        print("🔄 [PlayerView] URL changed, updating player")
        context.coordinator.stopTimeTracking()

        let asset = AVURLAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        let newPlayer = AVPlayer(playerItem: playerItem)
        newPlayer.allowsExternalPlayback = true
        newPlayer.automaticallyWaitsToMinimizeStalling = true

        uiViewController.player = newPlayer
        context.coordinator.player = newPlayer
        context.coordinator.observePlayerStatus(playerItem: playerItem)
        context.coordinator.startTimeTracking()
        newPlayer.play()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    class Coordinator {
        weak var viewModel: VideoPlayerViewModel?
        var player: AVPlayer?
        var timeObserver: Any?
        var statusObserver: NSKeyValueObservation?

        init(viewModel: VideoPlayerViewModel) {
            self.viewModel = viewModel
        }

        func observePlayerStatus(playerItem: AVPlayerItem) {
            // Observe player item status
            statusObserver = playerItem.observe(\.status, options: [.new]) { item, _ in
                switch item.status {
                case .readyToPlay:
                    print("✅ [PlayerView] Player ready to play")
                case .failed:
                    if let error = item.error {
                        print("❌ [PlayerView] Player failed: \(error.localizedDescription)")
                    }
                case .unknown:
                    print("⚠️ [PlayerView] Player status unknown")
                @unknown default:
                    print("⚠️ [PlayerView] Player status unknown default")
                }
            }
        }

        func startTimeTracking() {
            guard let player = player else { return }

            // Track playback time every 0.5 seconds
            let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
                guard let self = self, let viewModel = self.viewModel else { return }
                let currentTime = CMTimeGetSeconds(time)
                let currentTimeMs = Int(currentTime * 1000) // Convert to milliseconds
                viewModel.updateCurrentTime(Double(currentTimeMs))
            }

            // Track duration
            if let duration = player.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                if durationSeconds.isFinite && durationSeconds > 0 {
                    let durationMs = Int(durationSeconds * 1000)
                    self.viewModel?.updateDuration(Double(durationMs))
                }
            }
        }

        func stopTimeTracking() {
            print("🛑 [PlayerView.Coordinator] Stopping time tracking and cleaning up observers")

            if let observer = timeObserver, let player = player {
                player.removeTimeObserver(observer)
                timeObserver = nil
            }

            statusObserver?.invalidate()
            statusObserver = nil

            // Pause and clear player
            player?.pause()
            player = nil

            // Clear viewModel reference
            viewModel = nil
        }

        deinit {
            print("♻️ [PlayerView.Coordinator] Deinit called")
            stopTimeTracking()
        }
    }

    static func dismantleUIViewController(_ uiViewController: AVPlayerViewController, coordinator: Coordinator) {
        print("🧹 [PlayerView] Dismantling player view controller")

        // Pause and clean up player
        uiViewController.player?.pause()
        uiViewController.player = nil

        // Stop tracking
        coordinator.stopTimeTracking()
    }
}
