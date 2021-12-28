//
//  MZPickerControllerProtocol.swift
//  MZDatePicker
//
//  Created by 曾龙 on 2021/12/27.
//

import UIKit

public protocol MZPickerControllerDataSource: NSObjectProtocol {
    // PickerController列数
    func numberOfComponents(in picker: MZPickerController) -> Int

    // PickerController每列显示的行数
    func picker(_ picker: MZPickerController, numberOfRowsInComponent component: Int) -> Int
}

@objc
public protocol MZPickerControllerDelegate: NSObjectProtocol {
    
    // PickerController每列的宽度
    @objc optional func picker(_ picker: MZPickerController, widthForComponent component: Int) -> CGFloat

    // PickerController每列的行高
    @objc optional func picker(_ picker: MZPickerController, rowHeightForComponent component: Int) -> CGFloat
    
    // PickerController每个单元显示的String
    @objc optional func picker(_ picker: MZPickerController, titleForRow row: Int, forComponent component: Int) -> String

    // PickerController选择事件
    @objc optional func picker(_ picker: MZPickerController, didSelect rows:[Int])
}
