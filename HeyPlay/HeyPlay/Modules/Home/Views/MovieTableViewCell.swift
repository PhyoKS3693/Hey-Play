//
//  MovieTableViewCell.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        bgView.backgroundColor = .darkGrey
        
        setupCollectionView()
    }
    
    func setupCollectionView() {
        // Initialize the custom layout.
        let layout = HorizontalTwoRowLayout()
        layout.collectionView?.backgroundColor = .clear
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        // Initialize the collection view with the custom layout.
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerForCell(strID: FullMovieCollectionViewCell.identifier)
        collectionView.reloadData()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onClickViewAll(_ sender: Any) {
    }
    
}

extension MovieTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FullMovieCollectionViewCell.identifier, for: indexPath) as? FullMovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    
}
