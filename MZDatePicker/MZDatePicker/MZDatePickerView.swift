//
//  MZDatePickerView.swift
//  MZDatePicker
//
//  Created by 曾龙 on 2021/12/27.
//

import UIKit

/// 日期选择器类型
public enum MZDatePickerType {
    case yyyyMM             //年月
    case yyyyMMdd           //年月日
    case yyyyMMddHH         //年月日时
    case yyyyMMddHHmm       //年月日时分
    case yyyyMMddHHmmss     //年月日时分秒
}

@objc
public protocol MZDatePickerViewDelegate: NSObjectProtocol {
    @objc optional func datePickerView(_ datePickerView: MZDatePickerView, didSelectDate date: Date)
}

open class MZDatePickerView: UIView, MZPickerViewDataSource, MZPickerViewDelegate {
    
    /// 代理
    public var delegate: MZDatePickerViewDelegate?
    
    /// 起始时间    1970-01-01 08:00:00
    public var startDate: Date = Date(timeIntervalSince1970: 0)
    
    /// 结束时间    2050-01-01 00:00:00
    public var endDate: Date = Date(timeIntervalSince1970: 2524579199)
    
    /// 当前时间
    public var currentDate: Date = Date()
    
    /// 是否有单位、例如年、月、日等
    public var hasUnit: Bool = true
    
    /// 类型（默认年月日）
    public var type: MZDatePickerType = .yyyyMMdd
    
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
    
    /// 日期选择器范围
    lazy var ranges: [[String]] = MZDateUtil.getDateTimeRangeByDate(type: type, startDate: startDate, endDate: endDate, currentDate: currentDate)
    
    lazy var pickerView: MZPickerView = {
        let pickerView = MZPickerView()
        pickerView.dateSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup() {
        self.addSubview(pickerView)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        pickerView.frame = self.bounds
        pickerView.reloadData()
        let rows = MZDateUtil.getRowsByDate(dateTimeRange: self.ranges, currentDate: currentDate)
        pickerView.selectRows(rows)
    }
    
    //MARK:- MZPickerViewDataSource
    public func numberOfComponents(in pickerView: MZPickerView) -> Int {
        switch type {
        case .yyyyMM:
            return 2
        case .yyyyMMdd:
            return 3
        case .yyyyMMddHH:
            return 4
        case .yyyyMMddHHmm:
            return 5
        case .yyyyMMddHHmmss:
            return 6
        }
    }
    
    public func pickerView(_ pickerView: MZPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.ranges.count > 0 && self.ranges.count > component ? self.ranges[component].count : 0
    }
    
    //MARK:- MZPickerViewDelegate
    public func pickerView(_ pickerView: MZPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        let units = ["年", "月", "日", "时", "分", "秒"]
        return self.ranges[component][row] + (hasUnit ? units[component] : "")
    }
    
    public func pickerView(_ pickerView: MZPickerView, widthForComponent component: Int) -> CGFloat {
        let width = self.bounds.size.width / (CGFloat(self.ranges.count) + 0.2)
        return component == 0 ? width * 1.2 : width
    }
    
    public func pickerView(_ pickerView: MZPickerView, didSelectRow row: Int, inComponent component: Int) {
        var array = MZDateUtil.getArray(withDate: currentDate)
        array[component] = Int(self.ranges[component][row])!
        self.ranges = MZDateUtil.getDateTimeRangeByArray(type: type, startDate: startDate, endDate: endDate, currentTime: array)
        pickerView.reloadData(component+1)
        let rows = MZDateUtil.getRowsByTime(dateTimeRange: self.ranges, currentTime: array)
        pickerView.selectRows(rows, animated: false)
        var newArray = [String]()
        for i in 0..<rows.count {
            newArray.append(self.ranges[i][rows[i]])
        }
        currentDate = MZDateUtil.getDate(withArray: newArray)
        
        // 预防选中时间超出最大或最小时间
        if currentDate.timeIntervalSince1970 > endDate.timeIntervalSince1970 || currentDate.timeIntervalSince1970 < startDate.timeIntervalSince1970 {
            if currentDate.timeIntervalSince1970 > endDate.timeIntervalSince1970 {
                currentDate = endDate
            } else {
                currentDate = startDate
            }
            self.ranges = MZDateUtil.getDateTimeRangeByDate(type: type, startDate: startDate, endDate: endDate, currentDate: currentDate)
            pickerView.reloadData(component+1)
            let rows = MZDateUtil.getRowsByDate(dateTimeRange: self.ranges, currentDate: currentDate)
            pickerView.selectRows(rows, animated: false)
        }
        
        self.delegate?.datePickerView?(self, didSelectDate: currentDate)
    }
}
