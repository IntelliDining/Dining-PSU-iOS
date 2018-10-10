//
//  HourCell.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/10/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import UIKit

class HourCell: UITableViewCell {
    
    var daysOpen: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return l
    }()
    
    var timeOpen: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return l
    }()
    
    var calendar: Calendar = {
        let c = Calendar(identifier: .gregorian)
        return c
    }()
    
    var dateFormatter: DateFormatter = {
        let d = DateFormatter()
        d.dateFormat = "E"
        return d
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(timing: LocationHours) {
        let start = timing.dayOfWeekStart
        let end = timing.dayOfWeekEnd ?? 7
        
        if start == 1 && end == 7 {
            daysOpen.text = "Everyday"
        } else {
            var startComp = DateComponents()
            startComp.weekday = start
            var endComp = DateComponents()
            endComp.weekday = end
            
            let startDate = calendar.nextDate(after: Date(), matching: startComp, matchingPolicy: .nextTime)!
            let endDate = calendar.nextDate(after: Date(), matching: endComp, matchingPolicy: .nextTime)!
            daysOpen.text = dateFormatter.string(from: startDate) + " - " + dateFormatter.string(from: endDate)
        }
        
        timeOpen.text = timing.timeOpen + " - " + timing.timeClosed
    }

    func setupConstraints() {
        contentView.addSubview(daysOpen)
        daysOpen.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(16)
            make.centerY.equalTo(contentView)
        }
        
        contentView.addSubview(timeOpen)
        timeOpen.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-16)
            make.centerY.equalTo(contentView)
        }
    }

}
