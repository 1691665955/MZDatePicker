//
//  MZAlertController.swift
//  MZAlertController
//
//  Created by 曾龙 on 2021/12/16.
//

import UIKit

open class MZAlertController: UIViewController {

    public override var modalTransitionStyle: UIModalTransitionStyle {
        get {
            return .crossDissolve
        }
        set {}
    }
    
    public override var modalPresentationStyle: UIModalPresentationStyle {
        get {
            return .overFullScreen
        }
        set {}
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
        let blur = UIBlurEffect(style: .light)
        let visualView = UIVisualEffectView(effect: blur)
        visualView.frame = UIScreen.main.bounds
        visualView.alpha = 0.4
        visualView.backgroundColor = .black
        visualView.isUserInteractionEnabled = true
        view.insertSubview(visualView, at: 0)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        visualView.addGestureRecognizer(tap)
    }
    
    @objc open func dismissController() {
        
    }
}
