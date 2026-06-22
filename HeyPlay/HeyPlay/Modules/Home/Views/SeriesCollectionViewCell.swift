//
//  SeriesCollectionViewCell.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 08/08/2025.
//

import UIKit
import Kingfisher

class SeriesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblSeason: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgSeries: UIImageView!
    @IBOutlet weak var viewType: UIView!
    @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var lblType: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgSeries.clipsToBounds = true
        imgSeries.cornerRadius = 8

        // Set badge background with blur effect
        viewType.backgroundColor = .white.withAlphaComponent(0.04)

        // Add blur effect
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = viewType.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.layer.cornerRadius = 11
        blurView.clipsToBounds = true
        viewType.insertSubview(blurView, at: 0)

        viewType.layer.cornerRadius = 11
        viewType.clipsToBounds = true
    }

    // MARK: - Configure with Movie Data
    func configure(with movie: Movie) {
        lblName.text = movie.name

        // Hide episode label if count is 0 or text is empty
        if let totalEpisode = movie.totalEpisode, totalEpisode > 0,
           let episodeText = movie.totalEpisodeText, !episodeText.isEmpty {
            lblSeason.text = episodeText
            lblSeason.isHidden = false
        } else {
            lblSeason.text = nil
            lblSeason.isHidden = true
        }

        // Set subscription type badge
        if movie.isFree {
            lblType.text = "Free"
            imgType.image = UIImage(named: "ic-free")
        } else if movie.isVIP {
            lblType.text = "VIP"
            imgType.image = UIImage(named: "ic-vip")
        } else {
            lblType.text = movie.subscriptionTypeDesc
            imgType.image = UIImage(named: "ic-scribe")
        }

        // Load image using Kingfisher
        if let url = URL(string: movie.fullImageURL) {
            imgSeries.kf.setImage(
                with: url,
                placeholder: UIImage(named: "series"),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        } else {
            imgSeries.image = UIImage(named: "series")
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imgSeries.kf.cancelDownloadTask()
        imgSeries.image = nil
        lblName.text = nil
        lblSeason.text = nil
        lblType.text = nil
    }
}
