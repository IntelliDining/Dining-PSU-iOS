//
//  MenuItemCell.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/6/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {
    
    var labelStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.alignment = .leading
        return s
    }()
    
    var title: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return l
    }()
    
    var subtitle: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWith(_ menuItem: MenuItem) {
        title.text = menuItem.recipeName
        let kcal = menuItem.calories
        let fatCal = menuItem.caloriesFromFat
        subtitle.text = "kcal: \(kcal), fat: \(fatCal)"
    }
    
    func setConstraints() {
        labelStack.addArrangedSubview(title)
        labelStack.addArrangedSubview(subtitle)
        contentView.addSubview(labelStack)
        labelStack.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(16)
            make.centerY.equalTo(contentView)
        }
    }

}
