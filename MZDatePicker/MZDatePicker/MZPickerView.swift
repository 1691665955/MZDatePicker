//
//  MZPickerView.swift
//  MZDatePicker
//
//  Created by 曾龙 on 2021/12/24.
//

import UIKit

open class MZPickerView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    /// MZPickerView数据源
    public var dateSource: MZPickerViewDataSource? {
        didSet {
            self.setupUI()
        }
    }
    
    /// MZPickerView代理
    public var delegate: MZPickerViewDelegate?
    
    /// 未选中颜色
    public var normalColor: UIColor = .lightGray
    
    /// 选择颜色
    public var selectedColor: UIColor = .black
    
    /// 未选中字体
    public var normalFont: UIFont = .systemFont(ofSize: 16)
    
    /// 选中字体
    public var selectedFont: UIFont = .systemFont(ofSize: 16)
    
    /// 选中行
    public var rows = [Int]()
    
    lazy var pickers: [UITableView] = {
        let array = [UITableView]()
        return array
    }()
    
    /// 刷新数据
    /// - Parameter component: 刷新第几列开始后的所有列
    public func reloadData(_ component: Int = 0) {
        self.setupUI()
        for i in component..<self.pickers.count {
            let tableView = self.pickers[i]
            tableView.reloadData()
            if let parentView = self.superview {
                if parentView.isKind(of: MZDatePickerView.classForCoder()) {
                    continue
                }
            }
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .middle)
            self.rows[i] = 0
            self.delegate?.pickerView?(self, didSelectRow: 0, inComponent: i)
        }
    }
    
    /// 获取当前列选中的行
    /// - Parameter component: 当前列
    /// - Returns: 当前行
    public func selectedRow(in component: Int) -> Int {
        if component < 0 || component >= self.pickers.count {
            return 0
        }
        let tableView = self.pickers[component]
        return tableView.indexPathForSelectedRow?.row ?? 0
    }
    
    
    /// 设置默认值
    /// - Parameter rows: 默认选中行
    public func selectRows(_ rows: [Int], animated: Bool = false) {
        for index in 0..<self.pickers.count {
            let tableView = self.pickers[index]
            tableView.selectRow(at: IndexPath(row: rows[index], section: 0), animated: animated, scrollPosition: .middle)
        }
        self.rows = rows
    }
    
    func setupUI() {
        let components = self.dateSource?.numberOfComponents(in: self) ?? 1
        let isNeedsLayout = components != self.pickers.count
        if components < self.pickers.count {
            for i in (components..<self.pickers.count) {
                self.pickers[i].removeFromSuperview()
            }
            self.rows.removeLast(self.pickers.count - components)
            self.pickers.removeLast(self.pickers.count - components)
        } else if (components > self.pickers.count) {
            for i in self.pickers.count..<components {
                let tableView = UITableView(frame: CGRect.zero, style: .plain)
                tableView.dataSource = self
                tableView.delegate = self
                tableView.separatorStyle = .none
                tableView.tag = 100 + i
                tableView.showsVerticalScrollIndicator = false
                tableView.register(MZPickerCell.classForCoder(), forCellReuseIdentifier: "MZPickerCell")
                tableView.backgroundColor = .clear
                self.addSubview(tableView)
                self.pickers.append(tableView)
                self.rows.append(0)
            }
        }
        if let parentView = self.superview {
            if parentView.isKind(of: MZDatePickerView.classForCoder()) {
                self.setNeedsLayout()
            } else {
                if isNeedsLayout {
                    self.setNeedsLayout()
                }
            }
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        var widths = [CGFloat]()
        var totalWidth:CGFloat = 0.0
        for index in 0..<self.pickers.count {
            let width = self.delegate?.pickerView?(self, widthForComponent: index) ?? self.frame.size.width / CGFloat(self.pickers.count)
            widths.append(width)
            totalWidth += width
        }
        let space = (self.frame.width - totalWidth) / CGFloat(self.pickers.count + 1)
        totalWidth = 0
        
        for (index, tableView) in self.pickers.enumerated() {
            tableView.frame = CGRect(x: totalWidth + space , y: 0, width: widths[index], height: self.frame.height)
            totalWidth = tableView.frame.maxX
            tableView.contentInset = UIEdgeInsets(top: tableView.frame.height * 0.5, left: 0, bottom: tableView.frame.height * 0.5, right: 0)
            tableView.selectRow(at: IndexPath(row: rows.count > 0 ? rows[index] : 0, section: 0), animated: false, scrollPosition: .middle)
        }
    }
    
    //MARK:- UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dateSource?.pickerView(self, numberOfRowsInComponent: tableView.tag - 100) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MZPickerCell") as? MZPickerCell
        if cell == nil {
            cell = MZPickerCell.init(style: .default, reuseIdentifier: "MZPickerCell")
        }
        cell?.title = self.delegate?.pickerView?(self, titleForRow: indexPath.row, forComponent: tableView.tag - 100) ?? "\(tableView.tag - 100)-\(indexPath.row)"
        cell?.normalColor = self.normalColor
        cell?.selectedColor = self.selectedColor
        cell?.normalFont = self.normalFont
        cell?.selectedFont = self.selectedFont
        return cell!
    }
    
    //MARK:- UITableViewDelegate
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.delegate?.pickerView?(self, rowHeightForComponent: tableView.tag - 100) ?? 40.0
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle);
        // 是否真正更新了
        if self.rows[tableView.tag - 100] != indexPath.row{
            self.rows[tableView.tag - 100] = indexPath.row
            self.delegate?.pickerView?(self, didSelectRow: indexPath.row, inComponent: tableView.tag - 100)
            self.reloadData(tableView.tag - 99)
        }
    }
    
    //MARK:- UIScrollViewDelegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let tableView = scrollView as? UITableView {
            var indexPath = tableView.indexPathForRow(at: CGPoint(x: 0, y: tableView.contentOffset.y + tableView.contentInset.top))
            if indexPath == nil {
                if scrollView.contentOffset.y + tableView.contentInset.top > 0 {
                    indexPath = IndexPath(row: tableView.numberOfRows(inSection: 0) - 1, section: 0)
                } else {
                    indexPath = IndexPath(row: 0, section: 0)
                }
            }
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollToScrollStop = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating;
        if (scrollToScrollStop) {
            self.scrollViewDidEndScroll(scrollView);
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let scrollToScrollStop = scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating;
            if (scrollToScrollStop) {
                self.scrollViewDidEndScroll(scrollView);
            }
        }
    }
    
    func scrollViewDidEndScroll(_ scrollView: UIScrollView) {
        if let tableView = scrollView as? UITableView {
            var indexPath = tableView.indexPathForRow(at: CGPoint(x: 0, y: tableView.contentOffset.y + tableView.contentInset.top))
            if indexPath == nil {
                if scrollView.contentOffset.y + tableView.contentInset.top > 0 {
                    indexPath = IndexPath(row: tableView.numberOfRows(inSection: 0) - 1, section: 0)
                } else {
                    indexPath = IndexPath(row: 0, section: 0)
                }
            }

            
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
            // 是否真正更新了
            if self.rows[tableView.tag - 100] != indexPath!.row{
                self.rows[tableView.tag - 100] = indexPath!.row
                self.delegate?.pickerView?(self, didSelectRow: indexPath!.row, inComponent: tableView.tag - 100)
                self.reloadData(tableView.tag - 99)
            }
        }
    }
}
