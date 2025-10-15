//
//  UITableView + Extension.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import Foundation
import UIKit

extension UITableView {

   func registerForCell(strID: String) {
       register(UINib(nibName: strID, bundle: nil), forCellReuseIdentifier: strID)
   }
    
    func registerForHeaderFooterView(strID: String) {
        register(UINib(nibName: strID, bundle: nil), forHeaderFooterViewReuseIdentifier: strID)
    }
    
}

extension UICollectionView {

   func registerForCell(strID: String) {
       register(UINib(nibName: strID, bundle: nil), forCellWithReuseIdentifier: strID)
   }

    func registerForHeaderView(strID: String) {
        register(UINib(nibName: strID, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: strID)
    }

    func registerForFooterView(strID: String) {
        register(UINib(nibName: strID, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: strID)
    }
}
