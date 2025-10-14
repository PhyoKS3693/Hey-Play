//
//  MovieViewController.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 10/08/2025.
//

import UIKit

class MovieAndSeariesViewController: BaseViewController {
    @IBOutlet weak var bgView : UIView!
    @IBOutlet weak var collectionView : UICollectionView!
    override func viewDidLoad() {
        setupCollectionView()
    }
}
