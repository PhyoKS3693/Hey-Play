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

    // VIP Package Info Labels (programmatically added)
    private var lblVIPPackage: UILabel?
    private var lblExpireDate: UILabel?
    private var vipInfoContainer: UIStackView?

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

            // Show VIP Package info OR Subscribe button (mutually exclusive)
            if profile.hasActiveSubscription {
                // Has VIP Package - show VIP info, hide Subscribe button
                showVIPPackageInfo(planName: profile.safePlanName, expireDate: profile.expiredTime ?? "")
                btnSubscribe?.isHidden = true
            } else {
                // No VIP Package - hide VIP info, show Subscribe button
                hideVIPPackageInfo()
                btnSubscribe?.isHidden = false
                updateSubscribeButton(for: profile.subscriptionStatus)
            }
        } else {
            // Guest user - show Login button, hide VIP info
            lblGreeting?.text = getGreeting()
            lblUserName?.text = "Guest"
            imgUser?.image = UIImage(named: "ic-user")

            btnSubscribe?.isHidden = false
            btnSubscribe?.setTitle("Login", for: .normal)
            btnSubscribe?.backgroundColor = UIColor(named: "neon_Color")

            hideVIPPackageInfo()
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

    // MARK: - VIP Package Info Methods
    private func showVIPPackageInfo(planName: String, expireDate: String) {
        // Create labels if they don't exist
        if vipInfoContainer == nil {
            createVIPInfoLabels()
        }

        // Update labels
        lblVIPPackage?.text = planName
        lblExpireDate?.text = "Expire Date : \(expireDate)"

        // Show container
        vipInfoContainer?.isHidden = false
    }

    private func hideVIPPackageInfo() {
        vipInfoContainer?.isHidden = true
    }

    private func createVIPInfoLabels() {
        // Create VIP Package label
        let vipLabel = UILabel()
        vipLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        vipLabel.textColor = UIColor(named: "pink_Color")
        vipLabel.textAlignment = .right
        vipLabel.numberOfLines = 1

        // Create Expire Date label
        let expireLabel = UILabel()
        expireLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        expireLabel.textColor = .white
        expireLabel.textAlignment = .right
        expireLabel.numberOfLines = 1

        // Create container stack view
        let stackView = UIStackView(arrangedSubviews: [vipLabel, expireLabel])
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // Add to content view
        contentView.addSubview(stackView)

        // Set constraints (position on right side, aligned with greeting label top)
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: lblGreeting.topAnchor)
        ])

        // Store references
        lblVIPPackage = vipLabel
        lblExpireDate = expireLabel
        vipInfoContainer = stackView
    }
}
