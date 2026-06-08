//
//  HomeUserInfoTableViewCell.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 08/08/2025.
//

import UIKit
import Kingfisher

class HomeUserInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var lblGreeting: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnSubscribe: UIButton!

    var onSubscribeTapped: (() -> Void)?
    var onLoginTapped: (() -> Void)?

    private var isLoggedIn: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setupUI()
    }

    private func setupUI() {
        imgUser?.cornerRadius = (imgUser?.frame.height ?? 40) / 2
        imgUser?.clipsToBounds = true

        btnSubscribe?.cornerRadius = 20
        btnSubscribe?.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Configure with Profile Data
    func configure(with profile: Profile?) {
        isLoggedIn = AppDefaultsManager.shared.isLoggedIn

        if isLoggedIn, let profile = profile {
            // Logged in user
            lblGreeting?.text = getGreeting()
            lblUserName?.text = profile.safeName

            // Load profile image
            if let imageURL = profile.fullProfileImageURL, let url = URL(string: imageURL) {
                imgUser?.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "ic-user"),
                    options: [.transition(.fade(0.3))]
                )
            } else {
                imgUser?.image = UIImage(named: "ic-user")
            }

            // Update subscribe button based on subscription status
            updateSubscribeButton(for: profile.subscriptionStatus)
        } else {
            // Guest user
            lblGreeting?.text = getGreeting()
            lblUserName?.text = "Guest"
            imgUser?.image = UIImage(named: "ic-user")

            btnSubscribe?.setTitle("Login", for: .normal)
            btnSubscribe?.backgroundColor = UIColor(named: "neon_Color")
        }
    }

    private func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        default:
            return "Good Evening"
        }
    }

    private func updateSubscribeButton(for status: Profile.SubscriptionStatus) {
        switch status {
        case .free:
            btnSubscribe?.setTitle("Subscribe", for: .normal)
            btnSubscribe?.backgroundColor = UIColor(named: "pink_Color")
        case .vip:
            btnSubscribe?.setTitle("VIP", for: .normal)
            btnSubscribe?.backgroundColor = UIColor(named: "pink_Color")
        case .premium:
            btnSubscribe?.setTitle("Premium", for: .normal)
            btnSubscribe?.backgroundColor = UIColor(named: "pink_Color")
        }
    }

    @IBAction func onClickSubscribe(_ sender: Any) {
        if isLoggedIn {
            onSubscribeTapped?()
        } else {
            onLoginTapped?()
        }
    }
}
