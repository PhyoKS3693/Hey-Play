//
//  RecentTableViewCell.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import UIKit

class RecentTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnSeeAll: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        lblTitle.text = "Recent"
        
        bgView.backgroundColor = .darkGrey
        bgView.cornerRadius = 15
        bgView.clipsToBounds = true
        
        setupCollectionView()
        
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerForCell(strID: RecentCollectionViewCell.identifier)
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onClickSeeAll(_ sender: Any) {
    }
    
}

extension RecentTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentCollectionViewCell.identifier, for: indexPath) as? RecentCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 50) / 2, height: 136)
    }
}
