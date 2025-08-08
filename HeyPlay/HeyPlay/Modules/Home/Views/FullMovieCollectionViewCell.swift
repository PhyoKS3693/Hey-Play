//
//  FullMovieCollectionViewCell.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import UIKit

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
    }

}
