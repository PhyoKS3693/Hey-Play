//
//  SeriesTypeCollectionViewCell.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 10/08/2025.
//

import UIKit

class SeriesTypeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblType: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(with type : SeriesType , selectedType : SeriesType) {
        lblType.text = type.getTitle()
        bgView.backgroundColor = type == selectedType ? .pink : .darkGrey
    }

}
