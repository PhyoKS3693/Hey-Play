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

    var actionType: HotActionType = .addToWatchlist
    var actionClick: (() -> Void)?
    private var isActive: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.btnAction.setTitle("", for: .normal)
        self.lblActionName.textColor = .white
        self.btnAction.isUserInteractionEnabled = true
        self.isUserInteractionEnabled = true

        // Programmatically add target to ensure action is connected
        self.btnAction.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
    }

    @objc private func handleButtonTap() {
        print("🔥 [HotActionView] Button tapped programmatically for type: \(actionType)")
        actionClick?()
    }

    func setupView(withType type: HotActionType) {
        self.actionType = type
        switch type {
        case .addToWatchlist:
            self.lblActionName.text = "Watchlist"
        case .favorite:
            self.lblActionName.text = "0"
        }

        btnAction.setTitle("", for: .normal)
        btnAction.setImage(type.getInactiveImage(), for: .normal)
    }

    // MARK: - Update State
    func updateState(isActive: Bool) {
        self.isActive = isActive
        let image = isActive ? actionType.getActiveImage() : actionType.getInactiveImage()
        btnAction.setImage(image, for: .normal)
    }

    // MARK: - Update Like Count
    func updateLikeCount(_ count: Int) {
        if actionType == .favorite {
            if count >= 1000 {
                lblActionName.text = String(format: "%.1fK", Double(count) / 1000)
            } else {
                lblActionName.text = "\(count)"
            }
        }
    }

    @IBAction func onCalickAction(_ sender: Any) {
        print("🔥 [HotActionView] Button action called for type: \(actionType)")
        actionClick?()
    }
}
