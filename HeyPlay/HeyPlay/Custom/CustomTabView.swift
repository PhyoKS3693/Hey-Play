//
//  CustomTabView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import UIKit
import SnapKit

class CustomTabView: BaseView {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.btnAction.setTitle("", for: .normal)
        self.lblTitle.textColor = .lightGrey
    }
    
    @IBAction func onClickAction(_ sender: Any) {
    }
}
