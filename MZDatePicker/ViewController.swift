//
//  ViewController.swift
//  MZDatePicker
//
//  Created by 曾龙 on 2021/12/24.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width

class ViewController: UIViewController, MZPickerViewDataSource, MZPickerViewDelegate, MZPickerControllerDataSource, MZPickerControllerDelegate, MZDatePickerViewDelegate, MZDatePickerControllerDelegate {
    
    var dateSource: [[Any]] = [["动物", "植物", "真菌"],[["人类", "大象", "鲸鱼", "老鹰", "北极熊"], ["金丝楠木", "水杉", "杜鹃花", "康乃馨", "含羞草", "绿箩"], ["炭角菌", "羊肚菌", "牛肝菌"]]]

    lazy var pickerView: MZPickerView = {
        let pickerView = MZPickerView(frame: CGRect(x: 50, y: 100, width: SCREEN_WIDTH - 100, height: 200))
        pickerView.dateSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = .darkGray
        return pickerView
    }()
    
    lazy var pickerBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 50, y: 330, width: SCREEN_WIDTH - 100, height: 40)
        btn.setTitle("MZPickerController", for: .normal)
        btn.addTarget(self, action: #selector(showPickerController), for: .touchUpInside)
        btn.setTitleColor(.lightGray, for: .normal)
        return btn
    }()
    
    lazy var datePickerView: MZDatePickerView = {
        let pickerView = MZDatePickerView(frame: CGRect(x: 20, y: 400, width: SCREEN_WIDTH - 40, height: 200))
        pickerView.backgroundColor = .brown
        pickerView.type = .yyyyMMddHHmmss
        pickerView.endDate = Date(timeIntervalSinceNow: 320000)
        pickerView.startDate = Date(timeIntervalSinceNow: -320000)
        pickerView.delegate = self
        return pickerView
    }()
    
    lazy var datePickerBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 50, y: 630, width: SCREEN_WIDTH - 100, height: 40)
        btn.setTitle("MZDatePickerController", for: .normal)
        btn.addTarget(self, action: #selector(showDatePickerController), for: .touchUpInside)
        btn.setTitleColor(.lightGray, for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(pickerView)
        self.view.addSubview(pickerBtn)
        self.view.addSubview(datePickerView)
        self.view.addSubview(datePickerBtn)
    }
    
    @objc func showPickerController() {
        let picker = MZPickerController()
        picker.dataSource = self
        picker.delegate = self
        picker.selectedColor = .brown
        picker.selectedFont = .systemFont(ofSize: 18)
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func showDatePickerController() {
        let picker = MZDatePickerController()
        picker.delegate = self
        picker.selectedColor = .brown
        picker.selectedFont = .systemFont(ofSize: 18)
        picker.type = .yyyyMMddHHmm
        picker.endDate = Date(timeIntervalSinceNow: 11320000)
        picker.startDate = Date(timeIntervalSinceNow: -1320000)
        picker.currentDate = Date(timeIntervalSinceNow: 200000)
        self.present(picker, animated: true, completion: nil)
    }
    
    //MARK:- MZPickerViewDataSource
    func numberOfComponents(in pickerView: MZPickerView) -> Int {
        return self.dateSource.count
    }
    
    func pickerView(_ pickerView: MZPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.dateSource[0].count
        } else {
            let array = self.dateSource[1][pickerView.selectedRow(in: 0)] as! Array<String>
            return array.count
        }
    }
    
    //MARK:- MZPickerViewDelegate
    func pickerView(_ pickerView: MZPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            print("didSelect:\(self.dateSource[component][row])")
        } else {
            let array = self.dateSource[component][pickerView.selectedRow(in: 0)] as! Array<String>
            print("didSelect:\(array[row])")
        }
    }
    
    func pickerView(_ pickerView: MZPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        if component == 0 {
            return self.dateSource[component][row] as! String
        } else {
            let array = self.dateSource[component][pickerView.selectedRow(in: 0)] as! Array<String>
            return array[row]
        }
    }
    
    //MARK:- MZPickerControllerDataSource
    func numberOfComponents(in picker: MZPickerController) -> Int {
        return self.dateSource.count
    }
    
    func picker(_ picker: MZPickerController, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.dateSource[0].count
        } else {
            let array = self.dateSource[1][picker.selectedRow(in: 0)] as! Array<String>
            return array.count
        }
    }
    
    //MARK:- MZPickerControllerDelegate
    func picker(_ picker: MZPickerController, didSelect rows: [Int]) {
        let array = self.dateSource[1][picker.selectedRow(in: 0)] as! Array<String>
        print("didSelect:\(self.dateSource[0][rows[0]])-\(array[rows[1]])")
    }
    
    func picker(_ picker: MZPickerController, titleForRow row: Int, forComponent component: Int) -> String {
        if component == 0 {
            return self.dateSource[component][row] as! String
        } else {
            let array = self.dateSource[component][picker.selectedRow(in: 0)] as! Array<String>
            return array[row]
        }
    }
    
    //MARK:- MZDatePickerViewDelegate
    func datePickerView(_ datePickerView: MZDatePickerView, didSelectDate date: Date) {
        print(date)
    }
    
    //MARK:- MZDatePickerControllerDelegate
    
    func datePickerController(_ datePickerController: MZDatePickerController, didSelectDate date: Date) {
        print(date)
    }
}

