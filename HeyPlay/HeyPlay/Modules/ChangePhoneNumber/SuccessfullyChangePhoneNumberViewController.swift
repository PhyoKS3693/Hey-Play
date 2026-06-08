//
//  SuccessfullyChangePhoneNumberViewController.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/30/25.
//

import Foundation
import UIKit
import SwiftUI

final class SuccessfullyChangePhoneNumberViewController: UIHostingController<SuccessfullyChangePhoneNumberScreen> {
    
    init() {
        super.init(rootView: .init())
        rootView.host = .init(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "black_Color")
        
        rootView.didTapOK = { [weak self] in
            // Pop to root (back to profile/menu screen)
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
}
