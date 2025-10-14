//
//  HotViewController + Extension.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 10/08/2025.
//

import Foundation
import UIKit

extension HotViewController {
    func setupTableView() {
        tblHot.registerForCell(strID: HotTableViewCell.identifier)
        tblHot.showsVerticalScrollIndicator = false
        tblHot.isPagingEnabled = true
        tblHot.contentInset.top = 0
        tblHot.delegate = self
        tblHot.dataSource = self
        tblHot.separatorStyle = .none
        tblHot.reloadData()
    }
}

extension HotViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotTableViewCell.identifier, for: indexPath) as? HotTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height
    }
}
