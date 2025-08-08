//
//  RecentCollectionViewCell.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import UIKit

class RecentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgThumbnil: UIImageView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgThumbnil.cornerRadius = 8
    }
    @IBAction func onClickPlay(_ sender: Any) {
    }
    @IBAction func onClickDelete(_ sender: Any) {
    }
    
}
