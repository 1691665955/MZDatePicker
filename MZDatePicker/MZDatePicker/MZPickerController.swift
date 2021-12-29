//
//  MZPickerController.swift
//  MZDatePicker
//
//  Created by 曾龙 on 2021/12/27.
//

import MZAlertController

open class MZPickerController: MZActionSheetController, MZPickerViewDataSource, MZPickerViewDelegate {
    
    /// MZPickerController数据源
    public weak var dataSource: MZPickerControllerDataSource?
    
    /// MZPickerController代理
    public weak var delegate: MZPickerControllerDelegate?
    
    /// 取消按钮标题
    public var cancelTitle: String? {
        didSet {
            if cancelTitle != nil {
                cancelBtn.setTitle(cancelTitle, for: .normal)
            }
        }
    }
    
    /// 确定按钮标题
    public var confirmTitle: String? {
        didSet {
            if confirmTitle != nil {
                confirmBtn.setTitle(confirmTitle, for: .normal)
            }
        }
    }
    
    /// 取消按钮标题颜色
    public var cancelColor: UIColor? {
        didSet {
            if cancelColor != nil {
                cancelBtn.setTitleColor(cancelColor, for: .normal)
            }
        }
    }
    
    /// 确认按钮标题颜色
    public var confirmColor: UIColor? {
        didSet {
            if confirmColor != nil {
                confirmBtn.setTitleColor(confirmColor, for: .normal)
            }
        }
    }
    
    /// 未选中颜色
    public var normalColor: UIColor? {
        didSet {
            if normalColor != nil {
                pickerView.normalColor = normalColor!
            }
        }
    }
    
    /// 选中颜色
    public var selectedColor: UIColor? {
        didSet {
            if selectedColor != nil {
                pickerView.selectedColor = selectedColor!
            }
        }
    }
    
    /// 未选中字体
    public var normalFont: UIFont? {
        didSet {
            if normalFont != nil {
                pickerView.normalFont = normalFont!
            }
        }
    }
    
    /// 选中字体
    public var selectedFont: UIFont? {
        didSet {
            if selectedFont != nil {
                pickerView.selectedFont = selectedFont!
            }
        }
    }
    
    lazy var pickerView: MZPickerView = {
        var picker = MZPickerView(frame: CGRect(x: 20, y: 60, width: MZPickerView_SCREEN_WIDTH - 40, height: 200))
        picker.dateSource = self
        picker.delegate  = self
        return picker
    }()
    
    lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return btn
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: MZPickerView_SCREEN_WIDTH - 80, y: 0, width: 80, height: 40)
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(UIColor.brown, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        return btn
    }()
    
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: MZPickerView_SCREEN_WIDTH, height: 40))
        view.addSubview(cancelBtn)
        view.addSubview(confirmBtn)
        let topLine = UIView(frame: CGRect(x: 0, y: 0, width: MZPickerView_SCREEN_WIDTH, height: 1))
        topLine.backgroundColor = .lightGray
        view.addSubview(topLine)
        let bottomLine = UIView(frame: CGRect(x: 0, y: 39, width: MZPickerView_SCREEN_WIDTH, height: 1))
        bottomLine.backgroundColor = .lightGray
        view.addSubview(bottomLine)
        return view
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: MZPickerView_SCREEN_WIDTH, height: 280 + MZPickerView_SAFE_BOTTOM))
        contentView.addSubview(headerView)
        contentView.addSubview(pickerView)
        return contentView
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(contentView)
        self.Height = contentView.frame.height
    }
    
    /// 获取当前列选中的行
    /// - Parameter component: 当前列
    /// - Returns: 当前行
    public func selectedRow(in component: Int) -> Int {
        return pickerView.selectedRow(in: component)
    }
    
    /// 设置默认值
    /// - Parameter rows: 默认选中行
    public func selectRows(_ rows: [Int], animated: Bool = false) {
        pickerView.selectRows(rows, animated: animated)
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func confirm() {
        self.delegate?.picker?(self, didSelect: pickerView.rows)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- MZPickerViewDataSource
    public func numberOfComponents(in pickerView: MZPickerView) -> Int {
        return self.dataSource?.numberOfComponents(in: self) ?? 1
    }
    
    public func pickerView(_ pickerView: MZPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataSource?.picker(self, numberOfRowsInComponent: component) ?? 0
    }
    
    //MARK:- MZPickerViewDelegate
    
    public func pickerView(_ pickerView: MZPickerView, widthForComponent component: Int) -> CGFloat {
        return self.delegate?.picker?(self, widthForComponent: component) ?? pickerView.frame.size.width / CGFloat(self.dataSource?.numberOfComponents(in: self) ?? 1)
    }

    public func pickerView(_ pickerView: MZPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return self.delegate?.picker?(self, rowHeightForComponent: component) ?? 40.0
    }
    
    public func pickerView(_ pickerView: MZPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        return self.delegate?.picker?(self, titleForRow: row, forComponent: component) ?? "\(component)-\(row)"
    }
}

let MZPickerView_SCREEN_WIDTH = UIScreen.main.bounds.size.width

/// 底部安全区域高度
let MZPickerView_SAFE_BOTTOM: CGFloat = {
    if #available(iOS 11.0, *) {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
    return 0
}()
