//
//  ViewManager.swift
//  GenieflowTest
//
//  Created by GLB-311-PC on 18/12/17.
//  Copyright © 2017 SambitPrakash. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func add(asChildViewController childViewController: UIViewController, parentViewController: UIViewController) {
        parentViewController.addChildViewController(childViewController)
        self.addSubview(childViewController.view)
        childViewController.view.frame = self.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childViewController.didMove(toParentViewController: parentViewController)
    }
    
    func remove(asChildViewController viewController: UIViewController) {
        
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
}
