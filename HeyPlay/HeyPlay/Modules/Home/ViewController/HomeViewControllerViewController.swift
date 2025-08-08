//
//  HomeViewControllerViewController.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import UIKit

class HomeViewControllerViewController: BaseViewController {

    @IBOutlet weak var tblHome: UITableView! {
        didSet {
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
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var sectionList : [HomeSection] = [.user, .banner , .recent , .movie , .series]
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Is there a Navigation Controller? \(self.navigationController != nil)")

        setNavigationBarIcon()
        setRightBarItems()
    }

}
