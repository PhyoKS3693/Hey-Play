//
//  GoogleAdTableViewCell.swift
//  HeyPlay
//
//  Created by Claude on 18/06/2026.
//

import UIKit
import SwiftUI

@available(iOS 14.0, *)
class GoogleAdTableViewCell: UITableViewCell {

    private var hostingController: UIHostingController<BannerAdContainer>?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        contentView.backgroundColor = .black
        selectionStyle = .none
        setupBannerAd()
    }

    private func setupBannerAd() {
        // Remove previous hosting controller if exists
        if let hostingController = hostingController {
            hostingController.view.removeFromSuperview()
            hostingController.removeFromParent()
        }

        // Create SwiftUI banner ad view
        let bannerAdView = BannerAdContainer()
        let hostingController = UIHostingController(rootView: bannerAdView)
        self.hostingController = hostingController

        // Add hosting controller's view to cell
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        contentView.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            hostingController.view.heightAnchor.constraint(equalToConstant: 50) // Standard banner height
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        if let hostingController = hostingController {
            hostingController.view.removeFromSuperview()
            hostingController.removeFromParent()
            self.hostingController = nil
        }
    }
}
