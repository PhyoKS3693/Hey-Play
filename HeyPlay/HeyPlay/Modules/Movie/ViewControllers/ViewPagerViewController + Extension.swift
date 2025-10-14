//
//  ViewPagerViewController + Extension.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 10/08/2025.
//

import Foundation
import UIKit
extension ViewPagerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageContainerCollectionViewCell.identifier, for: indexPath) as! PageContainerCollectionViewCell
        let vc = viewControllers[indexPath.item]
        cell.embed(vc, into: self)
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        selectedIndex = page
        updateTabUI()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

extension ViewPagerViewController {
    func setNavTitle() {
        let titleItem = UIBarButtonItem(
            title: movieSeriesType.getTitle(),
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.leftBarButtonItem = titleItem
    }
    
    func setRightBarItems() {
        let searchImgView = UIImageView(
            image: UIImage(named: "ic-search")
        )
        let searchItem = UIBarButtonItem(
            customView: searchImgView
        )
        
        let notiImgView = UIImageView(
            image: UIImage(named: "ic-noti")
        )
        let notiItem = UIBarButtonItem(
            customView: notiImgView
        )
        
        navigationItem.rightBarButtonItems = [searchItem , notiItem]
    }
}
