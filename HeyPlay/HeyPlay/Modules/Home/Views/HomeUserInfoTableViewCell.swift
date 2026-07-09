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
    private var currentConfigState: String = "" // Track current configuration state

    // VIP Package Info Labels (programmatically added)
    private var lblVIPPackage: UILabel?
    private var lblExpireDate: UILabel?
    private var vipInfoContainer: UIStackView?

    override func awakeFromNib() {
        super.awakeFromNib()
        print("🔵 [HomeUserInfoCell] awakeFromNib called")
        self.selectionStyle = .none
        setupUI()
    }

    private func setupUI() {
        imgUser?.cornerRadius = (imgUser?.frame.height ?? 40) / 2
        imgUser?.clipsToBounds = true

        btnSubscribe?.cornerRadius = 20
        btnSubscribe?.clipsToBounds = true

        // Don't hide button initially - let configure handle visibility
        // This prevents flash when cell is recreated on tab switch
        btnSubscribe?.alpha = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        print("🟡 [HomeUserInfoCell] prepareForReuse called - currentState: '\(currentConfigState)'")
        // Don't reset currentConfigState to prevent unnecessary reconfiguration
        // The configure method will handle state changes
    }

    // MARK: - Configure with Profile Data
    func configure(with profile: Profile?) {
        isLoggedIn = AppDefaultsManager.shared.isLoggedIn

        // Create a state identifier to detect actual changes
        let newState: String
        if isLoggedIn, let profile = profile {
            if profile.hasActiveSubscription {
                newState = "vip_\(profile.safePlanName)_\(profile.expiredTime ?? "")"
            } else {
                // Convert subscription status to string
                let statusString: String
                switch profile.subscriptionStatus {
                case .free:
                    statusString = "free"
                case .vip:
                    statusString = "vip"
                case .premium:
                    statusString = "premium"
                }
                newState = "loggedIn_\(statusString)"
            }
        } else {
            newState = "guest"
        }

        print("🟢 [HomeUserInfoCell] configure called - currentState: '\(currentConfigState)', newState: '\(newState)'")

        // Only update UI if state has actually changed
        if currentConfigState == newState {
            print("⏭️ [HomeUserInfoCell] State unchanged - skipping update")
            return
        }

        print("🔄 [HomeUserInfoCell] State changed - updating UI from '\(currentConfigState)' to '\(newState)'")
        currentConfigState = newState

        // Always update basic info
        lblGreeting?.text = getGreeting()
        if isLoggedIn, let profile = profile {
            // Logged in user
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

            // Hide all first, then show only what's needed
            if profile.hasActiveSubscription {
                // Has VIP Package - show only VIP info
                hideSubscribeButton()
                showVIPPackageInfo(planName: profile.safePlanName, expireDate: profile.expiredTime ?? "")
            } else {
                // No VIP Package - show only Subscribe button
                hideVIPPackageInfo()
                updateSubscribeButton(for: profile.subscriptionStatus)
                showSubscribeButton()
            }
        } else {
            // Guest user - show only Login button
            lblUserName?.text = "Guest"
            imgUser?.image = UIImage(named: "ic_guest_user")

            hideVIPPackageInfo()
            btnSubscribe?.setTitle("Login", for: .normal)
            btnSubscribe?.backgroundColor = UIColor(named: "neon_Color")
            showSubscribeButton()
        }
    }

    // MARK: - Show/Hide Subscribe Button (No Animation to prevent flashing)
    private func showSubscribeButton() {
        // Only change if currently hidden (prevent unnecessary updates that cause flash)
        guard btnSubscribe?.isHidden == true else {
            print("⏭️ [HomeUserInfoCell] showSubscribeButton - already visible, skipping")
            return
        }
        print("👁️ [HomeUserInfoCell] showSubscribeButton - showing button")
        btnSubscribe?.isHidden = false
        btnSubscribe?.alpha = 1
    }

    private func hideSubscribeButton() {
        // Only change if currently visible (prevent unnecessary updates)
        guard btnSubscribe?.isHidden == false else {
            print("⏭️ [HomeUserInfoCell] hideSubscribeButton - already hidden, skipping")
            return
        }
        print("🙈 [HomeUserInfoCell] hideSubscribeButton - hiding button")
        btnSubscribe?.isHidden = true
        btnSubscribe?.alpha = 0
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

    // MARK: - VIP Package Info Methods (No Animation to prevent flashing)
    private func showVIPPackageInfo(planName: String, expireDate: String) {
        // Create labels if they don't exist
        if vipInfoContainer == nil {
            createVIPInfoLabels()
        }

        // Update labels
        lblVIPPackage?.text = planName
        lblExpireDate?.text = "Expire Date : \(expireDate)"

        // Only change if currently hidden (prevent unnecessary updates)
        guard vipInfoContainer?.isHidden == true else {
            print("⏭️ [HomeUserInfoCell] showVIPPackageInfo - already visible, skipping")
            return
        }

        print("💎 [HomeUserInfoCell] showVIPPackageInfo - showing VIP info")
        // Show container without animation
        vipInfoContainer?.isHidden = false
        vipInfoContainer?.alpha = 1
    }

    private func hideVIPPackageInfo() {
        // Only change if currently visible (prevent unnecessary updates)
        guard vipInfoContainer?.isHidden == false else {
            print("⏭️ [HomeUserInfoCell] hideVIPPackageInfo - already hidden, skipping")
            return
        }

        print("🙈 [HomeUserInfoCell] hideVIPPackageInfo - hiding VIP info")
        vipInfoContainer?.isHidden = true
        vipInfoContainer?.alpha = 0
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
        stackView.isHidden = true  // Hidden initially
        stackView.alpha = 1  // Keep alpha at 1

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
