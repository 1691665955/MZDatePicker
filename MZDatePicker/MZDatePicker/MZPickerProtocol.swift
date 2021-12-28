//
//  MZPickerProtocol.swift
//  MZDatePicker
//
//  Created by 曾龙 on 2021/12/24.
//

import UIKit

public protocol MZPickerViewDataSource: NSObjectProtocol {
    // PickerView列数
    func numberOfComponents(in pickerView: MZPickerView) -> Int

    // PickerView每列显示的行数
    func pickerView(_ pickerView: MZPickerView, numberOfRowsInComponent component: Int) -> Int
}

@objc
public protocol MZPickerViewDelegate: NSObjectProtocol {
    
    // PickerView每列的宽度
    @objc optional func pickerView(_ pickerView: MZPickerView, widthForComponent component: Int) -> CGFloat

    // PickerView每列的行高
    @objc optional func pickerView(_ pickerView: MZPickerView, rowHeightForComponent component: Int) -> CGFloat
    
    // PickerView每个单元显示的String
    @objc optional func pickerView(_ pickerView: MZPickerView, titleForRow row: Int, forComponent component: Int) -> String

    // PickerView每个单元的选择事件
    @objc optional func pickerView(_ pickerView: MZPickerView, didSelectRow row: Int, inComponent component: Int)
}
