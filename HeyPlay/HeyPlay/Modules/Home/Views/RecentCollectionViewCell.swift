//
//  RecentCollectionViewCell.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import UIKit
import Kingfisher

class RecentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgThumbnil: UIImageView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnDelete: UIButton!

    var onPlayTapped: (() -> Void)?
    var onDeleteTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgThumbnil.cornerRadius = 8
    }

    @IBAction func onClickPlay(_ sender: Any) {
        onPlayTapped?()
    }

    @IBAction func onClickDelete(_ sender: Any) {
        onDeleteTapped?()
    }

    // MARK: - Configure with Movie Data
    func configure(with movie: Movie, showDeleteButton: Bool = false) {
        lblName.text = movie.name

        // Show/hide delete button based on parameter
        btnDelete.isHidden = !showDeleteButton

        // Load image using Kingfisher
        if let url = URL(string: movie.fullImageURL) {
            imgThumbnil.kf.setImage(
                with: url,
                placeholder: UIImage(named: "recent"),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        } else {
            imgThumbnil.image = UIImage(named: "recent")
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imgThumbnil.kf.cancelDownloadTask()
        imgThumbnil.image = nil
        lblName.text = nil
        onPlayTapped = nil
        onDeleteTapped = nil
    }
}
