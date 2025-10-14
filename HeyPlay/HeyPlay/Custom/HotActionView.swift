//
//  HotActionView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 10/08/2025.
//

import UIKit


class HotActionView: BaseView {

    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var lblActionName: UILabel!
    
    var actionType : HotActionType = .addToWatchlist
    var actionClick : (()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.btnAction.setTitle("", for: .normal)
        self.lblActionName.textColor = .white
    }
    
    func setupView(withType type : HotActionType){
        self.actionType = type
        switch type {
        case .addToWatchlist:
            self.lblActionName.text = "Watchlist"
        case .favorite:
            self.lblActionName.text = "1.5 k"
        }
        
        btnAction.setTitle("", for: .normal)
        btnAction.setImage(type.getActiveImage(), for: .normal)
    }
    @IBAction func onCalickAction(_ sender: Any) {
        
    }
    
}
