//
//  FullMovieCollectionViewCell.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import UIKit
import Kingfisher

class FullMovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var viewType: UIView!
    @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var lblType: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgMovie.clipsToBounds = true
        imgMovie.cornerRadius = 8

        viewType.backgroundColor = .white.withAlphaComponent(0.4)
    }

    // MARK: - Configure with Movie Data
    func configure(with movie: Movie) {
        lblName.text = movie.name

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
            imgMovie.kf.setImage(
                with: url,
                placeholder: UIImage(named: "image1"),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        } else {
            imgMovie.image = UIImage(named: "image1")
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imgMovie.kf.cancelDownloadTask()
        imgMovie.image = nil
        lblName.text = nil
        lblType.text = nil
    }
}
