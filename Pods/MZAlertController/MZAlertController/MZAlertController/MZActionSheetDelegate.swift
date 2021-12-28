//
//  MZActionSheetDelegate.swift
//  MZAlertController
//
//  Created by 曾龙 on 2021/12/16.
//

import UIKit

class MZActionSheetDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return MZPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
