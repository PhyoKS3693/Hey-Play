//
//  HotTableViewCell.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 08/08/2025.
//

import UIKit
import Kingfisher

class HotTableViewCell: UITableViewCell {

    @IBOutlet weak var actionStackView: UIStackView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var visualView: UIVisualEffectView!
    @IBOutlet weak var imgPreview: UIImageView!
    @IBOutlet weak var favoriteView: HotActionView!
    @IBOutlet weak var addToWatchView: HotActionView!

    // Video Player
    private var playerView: ReelPlayerView?

    // Callbacks
    var onFavoriteTapped: (() -> Void)?
    var onWatchLaterTapped: (() -> Void)?
    var onNextTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = .none
        self.backgroundColor = .black
        self.contentView.backgroundColor = .black

        visualView?.clipsToBounds = true
        visualView?.layer.cornerRadius = 16

        imgPreview?.contentMode = .scaleAspectFill
        imgPreview?.clipsToBounds = true

        // Make logo circular (55/2 = 27.5)
        imgLogo?.layer.cornerRadius = 27.5
        imgLogo?.clipsToBounds = true
        imgLogo?.contentMode = .scaleAspectFill

        favoriteView?.setupView(withType: .favorite)
        addToWatchView?.setupView(withType: .addToWatchlist)

        setupActions()
        setupPlayerView()
    }

    private func setupPlayerView() {
        // Create player view
        let player = ReelPlayerView()
        player.translatesAutoresizingMaskIntoConstraints = false
        playerView = player

        // Add player view behind imgPreview
        if let imgPreview = imgPreview {
            contentView.insertSubview(player, belowSubview: imgPreview)

            NSLayoutConstraint.activate([
                player.topAnchor.constraint(equalTo: imgPreview.topAnchor),
                player.leadingAnchor.constraint(equalTo: imgPreview.leadingAnchor),
                player.trailingAnchor.constraint(equalTo: imgPreview.trailingAnchor),
                player.bottomAnchor.constraint(equalTo: imgPreview.bottomAnchor)
            ])
        }

        // Hide the static image initially
        imgPreview?.isHidden = true
    }

    private func setupActions() {
        // Use HotActionView's built-in button action callback
        favoriteView?.actionClick = { [weak self] in
            print("🔥 [HotTableViewCell] Favorite button tapped")
            self?.onFavoriteTapped?()
        }

        addToWatchView?.actionClick = { [weak self] in
            print("🔥 [HotTableViewCell] Watch later button tapped")
            self?.onWatchLaterTapped?()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Configure with Reel Data
    func configure(with reel: Reel) {
        // Set title
        lblName?.text = reel.safeTitle

        // Set description
        lblDesc?.text = reel.safeDescription

        // Setup video player with streaming URL
        if let streamingURL = reel.fullStreamingURL {
            print("🎬 [HotTableViewCell] Setting up video: \(streamingURL)")
            playerView?.setupVideo(with: streamingURL)
            imgPreview?.isHidden = true // Hide thumbnail when video is available
        } else {
            // Fallback to thumbnail if no streaming URL
            print("⚠️ [HotTableViewCell] No streaming URL, showing thumbnail")
            imgPreview?.isHidden = false
            playerView?.cleanupPlayer()

            if !reel.fullThumbnailURL.isEmpty, let url = URL(string: reel.fullThumbnailURL) {
                imgPreview?.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "image1"),
                    options: [
                        .transition(.fade(0.3)),
                        .cacheOriginalImage
                    ]
                )
            } else {
                imgPreview?.image = UIImage(named: "image1")
            }
        }

        // Update favorite state and count
        if let isFavourite = reel.isFavourite {
            favoriteView?.updateState(isActive: isFavourite)
        }
        favoriteView?.updateLikeCount(reel.reactionCountInt)

        // Reset watch later state (API doesn't provide this field)
        addToWatchView?.updateState(isActive: false)
    }

    // MARK: - Playback Control
    func playVideo() {
        playerView?.play()
    }

    func pauseVideo() {
        playerView?.pause()
    }

    func stopVideo() {
        playerView?.stop()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        // Stop and cleanup video player
        playerView?.cleanupPlayer()

        imgPreview?.kf.cancelDownloadTask()
        imgPreview?.image = nil
        lblName?.text = nil
        lblDesc?.text = nil
        onFavoriteTapped = nil
        onWatchLaterTapped = nil
        onNextTapped = nil
    }

    @IBAction func onClickNext(_ sender: Any) {
        onNextTapped?()
    }
}
