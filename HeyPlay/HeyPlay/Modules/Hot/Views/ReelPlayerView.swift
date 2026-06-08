//
//  ReelPlayerView.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 06/02/26.
//

import UIKit
import AVFoundation

class ReelPlayerView: UIView {

    // MARK: - Properties
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var playerItem: AVPlayerItem?
    private var playbackObserver: Any?
    private var timeObserver: Any?

    var isPlaying: Bool = false
    var currentVideoURL: String?

    // Loading indicator
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // Play/Pause icon
    private let playPauseIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .black

        // Add loading indicator
        addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        // Add play/pause icon
        addSubview(playPauseIcon)
        NSLayoutConstraint.activate([
            playPauseIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            playPauseIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            playPauseIcon.widthAnchor.constraint(equalToConstant: 80),
            playPauseIcon.heightAnchor.constraint(equalToConstant: 80)
        ])

        // Add tap gesture to play/pause
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }

    // MARK: - Setup Video
    func setupVideo(with urlString: String?) {
        guard let urlString = urlString, !urlString.isEmpty else {
            print("❌ [ReelPlayerView] Invalid video URL")
            return
        }

        // Don't reload if same URL
        if currentVideoURL == urlString, player != nil {
            return
        }

        currentVideoURL = urlString
        cleanupPlayer()

        guard let url = URL(string: urlString) else {
            print("❌ [ReelPlayerView] Failed to create URL: \(urlString)")
            return
        }

        print("🎬 [ReelPlayerView] Setting up video: \(urlString)")
        loadingIndicator.startAnimating()

        // Create player item
        playerItem = AVPlayerItem(url: url)

        // Create player
        player = AVPlayer(playerItem: playerItem)
        player?.automaticallyWaitsToMinimizeStalling = true

        // Create player layer
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        playerLayer?.frame = bounds

        if let playerLayer = playerLayer {
            layer.insertSublayer(playerLayer, at: 0)
        }

        // Add observers
        setupObservers()
    }

    // MARK: - Setup Observers
    private func setupObservers() {
        // Observe when video ends
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(videoDidEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )

        // Observe playback status
        playerItem?.addObserver(
            self,
            forKeyPath: "status",
            options: [.new, .old],
            context: nil
        )

        // Observe buffer status
        playerItem?.addObserver(
            self,
            forKeyPath: "playbackBufferEmpty",
            options: .new,
            context: nil
        )

        playerItem?.addObserver(
            self,
            forKeyPath: "playbackLikelyToKeepUp",
            options: .new,
            context: nil
        )
    }

    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if let statusNumber = change?[.newKey] as? NSNumber {
                let status = AVPlayerItem.Status(rawValue: statusNumber.intValue) ?? .unknown

                switch status {
                case .readyToPlay:
                    print("✅ [ReelPlayerView] Video ready to play")
                    loadingIndicator.stopAnimating()
                case .failed:
                    print("❌ [ReelPlayerView] Video failed to load")
                    loadingIndicator.stopAnimating()
                case .unknown:
                    print("⚠️ [ReelPlayerView] Video status unknown")
                @unknown default:
                    break
                }
            }
        } else if keyPath == "playbackBufferEmpty" {
            if playerItem?.isPlaybackBufferEmpty == true {
                loadingIndicator.startAnimating()
            }
        } else if keyPath == "playbackLikelyToKeepUp" {
            if playerItem?.isPlaybackLikelyToKeepUp == true {
                loadingIndicator.stopAnimating()
            }
        }
    }

    // MARK: - Playback Controls
    func play() {
        guard let player = player else { return }
        player.play()
        isPlaying = true
        print("▶️ [ReelPlayerView] Playing")
        showPlayPauseIcon(isPlaying: true)
    }

    func pause() {
        guard let player = player else { return }
        player.pause()
        isPlaying = false
        print("⏸ [ReelPlayerView] Paused")
        showPlayPauseIcon(isPlaying: false)
    }

    func stop() {
        player?.pause()
        player?.seek(to: .zero)
        isPlaying = false
    }

    @objc private func handleTap() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    // MARK: - Show Play/Pause Icon
    private func showPlayPauseIcon(isPlaying: Bool) {
        playPauseIcon.image = UIImage(systemName: isPlaying ? "play.fill" : "pause.fill")

        UIView.animate(withDuration: 0.2, animations: {
            self.playPauseIcon.alpha = 1.0
            self.playPauseIcon.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0.3, animations: {
                self.playPauseIcon.alpha = 0
                self.playPauseIcon.transform = .identity
            })
        }
    }

    // MARK: - Video Loop
    @objc private func videoDidEnd() {
        print("🔄 [ReelPlayerView] Video ended, looping...")
        player?.seek(to: .zero)
        player?.play()
    }

    // MARK: - Cleanup
    func cleanupPlayer() {
        // Remove observers
        NotificationCenter.default.removeObserver(self)
        playerItem?.removeObserver(self, forKeyPath: "status")
        playerItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
        playerItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")

        // Stop playback
        player?.pause()
        playerLayer?.removeFromSuperlayer()

        // Clean up
        player = nil
        playerLayer = nil
        playerItem = nil
        isPlaying = false
    }

    deinit {
        cleanupPlayer()
        print("🗑 [ReelPlayerView] Deallocated")
    }
}
