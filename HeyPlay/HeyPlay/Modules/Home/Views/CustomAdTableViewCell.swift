//
//  CustomAdTableViewCell.swift
//  HeyPlay
//
//  Created by Claude on 18/06/2026.
//

import UIKit
import SwiftUI

@available(iOS 14.0, *)
class CustomAdTableViewCell: UITableViewCell {

    private var hostingController: UIHostingController<CustomAdBannerView>?

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
    }

    func configure(with adsSetting: AdsSetting) {
        // Remove previous hosting controller if exists
        if let hostingController = hostingController {
            hostingController.view.removeFromSuperview()
            hostingController.removeFromParent()
        }

        // Create SwiftUI view
        let customAdView = CustomAdBannerView(adsSetting: adsSetting)
        let hostingController = UIHostingController(rootView: customAdView)
        self.hostingController = hostingController

        // Add hosting controller's view to cell
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        contentView.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            hostingController.view.heightAnchor.constraint(equalToConstant: 66) // 50 height + 8 top + 8 bottom padding
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
