//
//  HomeViewController + Extension .swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import Foundation
import UIKit

extension HomeViewController {
    func setupTableView() {
        tblHome.delegate = self
        tblHome.dataSource = self
        tblHome.registerForCell(strID: HomeUserInfoTableViewCell.identifier)
        tblHome.registerForCell(strID: BannerTableViewCell.identifier)
        tblHome.registerForCell(strID: RecentTableViewCell.identifier)
        tblHome.registerForCell(strID: MovieTableViewCell.identifier)
        tblHome.registerForCell(strID: SeriesTableViewCell.identifier)
        tblHome.showsVerticalScrollIndicator = false
        tblHome.reloadData()
    }
}
extension HomeViewController : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionList[indexPath.section] {
        case .user:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeUserInfoTableViewCell.identifier, for: indexPath) as? HomeUserInfoTableViewCell else {
                return UITableViewCell()
            }
            return cell
         case .banner:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BannerTableViewCell.identifier, for: indexPath) as? BannerTableViewCell else {
                return UITableViewCell()
            }
            cell.items = [UIImage(named: "image1") , UIImage(named: "image2"), UIImage(named: "image3")]
            return cell
            
        case .recent:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentTableViewCell.identifier, for: indexPath) as? RecentTableViewCell else {
                return UITableViewCell()
            }
            cell.navigateToMovieDetail = { [weak self]  id in
                ViewNavigation.shared.showMovieDetail(detailType: .movie)
            }
            return cell
        case .movie:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
                return UITableViewCell()
            }
            cell.navigateToMovieDetail = { [weak self]  id in
                ViewNavigation.shared.showMovieDetail(detailType: .movie)
            }
            return cell
        case .series:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SeriesTableViewCell.identifier, for: indexPath ) as? SeriesTableViewCell else {
                return UITableViewCell()
            }
        
            cell.navigateToSeriesDetail = { [weak self]  id in
                ViewNavigation.shared.showMovieDetail(detailType: .series)
            }
            
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == sectionList.last?.rawValue ?? 0 {
            DispatchQueue.main.async {
                self.bottomConstraint.constant = 70
            }
        }
        else {
            DispatchQueue.main.async {
                self.bottomConstraint.constant = 0
            }
        }
        
    }
}

extension HomeViewController {
    func setNavigationBarIcon() {
        let logoImageView = UIImageView(
            image: UIImage(named: "ic-nav-bar")
        )
        let logoItem = UIBarButtonItem(
            customView: logoImageView
        )
        navigationItem.leftBarButtonItem = logoItem
    }
    
    func setRightBarItems() {
        let searchItem = UIBarButtonItem(
            image:  UIImage(named: "ic-search")?.withRenderingMode(.alwaysOriginal),
            style: .done,
            target: self,
            action: #selector(presentSearch)
        )
        
        let notiItem = UIBarButtonItem(
            image:  UIImage(named: "ic-noti")?.withRenderingMode(.alwaysOriginal),
            style: .done,
            target: self,
            action: #selector(presentNoti)
        )
        
        navigationItem.rightBarButtonItems = [searchItem , notiItem]
    }
    
    @objc func presentSearch() {
        ViewNavigation.shared.showSearchView()
    }
    
    @objc func presentNoti() {
        ViewNavigation.shared.showNotification()
    }
}
