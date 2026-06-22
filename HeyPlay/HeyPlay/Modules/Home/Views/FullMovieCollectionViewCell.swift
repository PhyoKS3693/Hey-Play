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

        // Prevent content from shrinking the cell
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Remove any existing height constraints on image that might limit cell height
        removeHeightConstraints(from: imgMovie)

        // Set very low content hugging/compression for image so it fills available space
        imgMovie.setContentHuggingPriority(.init(1), for: .vertical)
        imgMovie.setContentHuggingPriority(.init(1), for: .horizontal)
        imgMovie.setContentCompressionResistancePriority(.init(1), for: .vertical)

        // Keep label at normal priorities so it doesn't disappear
        lblName.setContentHuggingPriority(.defaultHigh, for: .vertical)
        lblName.setContentCompressionResistancePriority(.required, for: .vertical)

        // Ensure label has reasonable constraints - 1 line for all layouts
        lblName.numberOfLines = 1
        lblName.lineBreakMode = .byTruncatingTail

        imgMovie.clipsToBounds = true
        imgMovie.cornerRadius = 8
        imgMovie.contentMode = .scaleAspectFill // Ensure image fills the entire frame

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

    private func removeHeightConstraints(from view: UIView) {
        // Remove any height constraints that might limit the view
        view.constraints.forEach { constraint in
            if constraint.firstAttribute == .height || constraint.secondAttribute == .height {
                constraint.isActive = false
            }
        }
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        // Return the exact size from layout without any modification
        // This prevents the cell from calculating its own size based on content
        return layoutAttributes
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        // Return the target size exactly as specified by the layout
        return targetSize
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

    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure contentView fills the entire cell
        contentView.frame = bounds
    }
}
