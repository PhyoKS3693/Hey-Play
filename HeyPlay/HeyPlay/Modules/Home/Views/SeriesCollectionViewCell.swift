//
//  SeriesCollectionViewCell.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 08/08/2025.
//

import UIKit

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
    }

}
