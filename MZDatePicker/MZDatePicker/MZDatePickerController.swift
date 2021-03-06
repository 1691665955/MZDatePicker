//
//  MZDatePickerController.swift
//  MZDatePicker
//
//  Created by 曾龙 on 2021/12/28.
//

import MZAlertController

@objc
public protocol MZDatePickerControllerDelegate: NSObjectProtocol {
    @objc optional func datePickerController(_ datePickerController: MZDatePickerController, didSelectDate date: Date)
}


open class MZDatePickerController: MZActionSheetController {
    
    /// 代理
    public weak var delegate: MZDatePickerControllerDelegate?
    
    /// 起始时间    1970-01-01 08:00:00
    public var startDate: Date? {
        didSet {
            if startDate != nil {
                pickerView.startDate = startDate!
            }
        }
    }
    
    /// 结束时间    2050-01-01 00:00:00
    public var endDate: Date? {
        didSet {
            if endDate != nil {
                pickerView.endDate = endDate!
            }
        }
    }
    
    /// 当前时间
    public var currentDate: Date? {
        didSet {
            if currentDate != nil {
                pickerView.currentDate = currentDate!
            }
        }
    }
    
    /// 是否有单位、例如年、月、日等
    public var hasUnit: Bool? {
        didSet {
            if hasUnit != nil {
                pickerView.hasUnit = hasUnit!
            }
        }
    }
    
    /// 类型（默认年月日）
    public var type: MZDatePickerType? {
        didSet {
            if type != nil {
                pickerView.type = type!
            }
        }
    }
    
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
    
    lazy var pickerView: MZDatePickerView = {
        var picker = MZDatePickerView(frame: CGRect(x: 20, y: 60, width: MZPickerView_SCREEN_WIDTH - 40, height: 200))
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

    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func confirm() {
        self.delegate?.datePickerController?(self, didSelectDate: pickerView.currentDate)
        self.dismiss(animated: true, completion: nil)
    }
}
