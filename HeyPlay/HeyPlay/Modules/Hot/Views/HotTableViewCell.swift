//
//  HotTableViewCell.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 08/08/2025.
//

import UIKit

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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        visualView.clipsToBounds = true
        visualView.cornerRadius = 10
        
        favoriteView.setupView(withType: .favorite)
        addToWatchView.setupView(withType: .addToWatchlist)
    }
 

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onClickNext(_ sender: Any) {
    }
    
}
