//
//  BannerCollectionViewCell.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 08/08/2025.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView.clipsToBounds = true
        imgView.cornerRadius = 8
        imgView.contentMode = .scaleAspectFill
    }

}
