//
//  BannerTableViewCell.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import UIKit
import FSPagerView
class BannerTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var items = [UIImage?](){
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        setupCollectionView()
    }

    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerForCell(strID: BannerCollectionViewCell.identifier)
        collectionView.reloadData()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension BannerTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as? BannerCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.imgView.image = items[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 20, height: collectionView.bounds.height)
    }
}
