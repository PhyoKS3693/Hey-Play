//
//  HostController.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/23/25.
//

import SwiftUI

public class HostController {
    public internal(set)
    weak var controller: UIViewController?
    
    public init(_ controller: UIViewController? = nil) {
        self.controller = controller
    }
    
    public var navigationController: UINavigationController? {
        controller?.navigationController
    }
    
    public func present(_ viewController: UIViewController, animated: Bool = true) {
        controller?.present(viewController, animated: animated)
    }
    
    public func pushViewController(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(
            viewController, animated: animated
        )
    }
    
    public func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        controller?.dismiss(animated: animated, completion: completion)
    }
    
    public func popViewController(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }
}
