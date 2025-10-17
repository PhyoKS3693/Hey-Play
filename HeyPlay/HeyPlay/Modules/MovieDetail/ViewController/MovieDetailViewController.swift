//
//  MovieDetailViewController.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 16/10/2025.
//

import UIKit
import SwiftUI

enum DetailType {
    case movie
    case series
}
class MovieDetailViewController: BaseViewController {
    var detailType : DetailType = .movie
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        let detailView = MovieDetailView(detailType : detailType)
        let hostingController = UIHostingController(rootView: detailView)

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        // Set constraints
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview().inset(0)
        }
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
    }
}
