//
//  MZPickerCell.swift
//  MZDatePicker
//
//  Created by 曾龙 on 2021/12/24.
//

import UIKit

class MZPickerCell: UITableViewCell {

    lazy var titleLB: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    var normalColor: UIColor = .lightGray
    var selectedColor: UIColor = .black
    var normalFont: UIFont = .systemFont(ofSize: 16)
    var selectedFont: UIFont = .systemFont(ofSize: 16)
    
    var title: String? {
        didSet {
            self.titleLB.text = title
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    func setup() {
        self.backgroundColor = .clear
        self.contentView.addSubview(titleLB)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        titleLB.textColor = selected ? selectedColor : normalColor
        titleLB.font = selected ? selectedFont : normalFont
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLB.frame = self.contentView.bounds
    }

}
