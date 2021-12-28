//
//  MZActionSheetController.swift
//  MZAlertController
//
//  Created by 曾龙 on 2021/12/16.
//

import UIKit

open class MZActionSheetController: UIViewController {

    open var Height: CGFloat!
    var mzDelegate: MZActionSheetDelegate!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setDelegate()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        setDelegate()
    }
    
    func setDelegate() {
        self.mzDelegate = MZActionSheetDelegate()
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self.mzDelegate
    }
    
}
