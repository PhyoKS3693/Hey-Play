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

    // Legacy support for UIImage
    var items = [UIImage?]() {
        didSet {
            banners = []
            collectionView.reloadData()
        }
    }

    // New Banner data support
    var banners: [Banner] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    var onBannerTapped: ((Banner) -> Void)?

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

    // MARK: - Configure with Banner Data
    func configure(with banners: [Banner]) {
        self.banners = banners
    }
}

extension BannerTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.isEmpty ? items.count : banners.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as? BannerCollectionViewCell else {
            return UICollectionViewCell()
        }

        if !banners.isEmpty {
            cell.configure(with: banners[indexPath.item])
        } else if indexPath.item < items.count {
            cell.imgView.image = items[indexPath.item]
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !banners.isEmpty {
            onBannerTapped?(banners[indexPath.item])
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 20, height: collectionView.bounds.height)
    }
}
