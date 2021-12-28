//
//  MZPresentationController.swift
//  MZAlertController
//
//  Created by 曾龙 on 2021/12/16.
//

import UIKit

let MZPresentationController_WIDTH  = UIScreen.main.bounds.size.width
let MZPresentationController_Height = UIScreen.main.bounds.size.height

class MZPresentationController: UIPresentationController {
    lazy var visualView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        let visualView = UIVisualEffectView(effect: blur)
        visualView.alpha = 0.3
        visualView.backgroundColor = .black
        return visualView
    }()
    
    override func presentationTransitionWillBegin() {
        self.visualView.alpha = 0.3
        self.visualView.frame = self.containerView?.bounds ?? UIScreen.main.bounds
        self.containerView?.addSubview(visualView)
    }
    
    override func dismissalTransitionWillBegin() {
        self.visualView.alpha = 0.0
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.visualView.removeFromSuperview()
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let actionSheet = self.presentedViewController as! MZActionSheetController
        self.presentedView?.frame = CGRect(x: 0, y: MZPresentationController_Height - actionSheet.Height, width: MZPresentationController_WIDTH, height: actionSheet.Height)
        return self.presentedView?.frame ?? UIScreen.main.bounds
    }
}
