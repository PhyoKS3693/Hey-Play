//
//  HomeUserInfoTableViewCell.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 08/08/2025.
//

import UIKit

class HomeUserInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var lblGreeting: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnSubscribe: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        btnSubscribe.cornerRadius = 20
        btnSubscribe.clipsToBounds = true
    }
    
    @IBAction func onClickSubscribe(_ sender: Any) {
    }
}
