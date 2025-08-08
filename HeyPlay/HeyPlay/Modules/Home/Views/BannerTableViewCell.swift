//
//  BannerTableViewCell.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import UIKit
import FSPagerView
class BannerTableViewCell: UITableViewCell {

//    @IBOutlet weak var pagerView: FSPagerView! {
//        didSet {
//            pagerView.delegate = self
//            pagerView.dataSource = self
//            pagerView.cornerRadius = 10
//            pagerView.interitemSpacing = 10
//            pagerView.transformer = FSPagerViewTransformer(type: .linear)
//            pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
//            pagerView.reloadData()
//        }
//    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    var items = [UIImage?](){
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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

//extension BannerTableViewCell : FSPagerViewDataSource, FSPagerViewDelegate {
//    func numberOfItems(in pagerView: FSPagerView) -> Int {
//        return items.count
//    }
//    
//    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
//        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
//        cell.imageView?.image = items[index] ?? UIImage()
//        cell.imageView?.cornerRadius = 10
//        cell.imageView?.clipsToBounds = true
//        return cell
//    }
//}
