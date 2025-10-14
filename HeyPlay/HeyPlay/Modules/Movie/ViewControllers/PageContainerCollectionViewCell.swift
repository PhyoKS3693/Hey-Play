//
//  PageContainerCollectionViewCell.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 10/08/2025.
//

import UIKit
class PageContainerCollectionViewCell: UICollectionViewCell {
    var viewController: UIViewController?

    func embed(_ vc: UIViewController, into parent: UIViewController) {
        // Remove old
        viewController?.willMove(toParent: nil)
        viewController?.view.removeFromSuperview()
        viewController?.removeFromParent()

        // Add new
        parent.addChild(vc)
        contentView.addSubview(vc.view)
        vc.view.frame = contentView.bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc.didMove(toParent: parent)
        viewController = vc
    }
}

