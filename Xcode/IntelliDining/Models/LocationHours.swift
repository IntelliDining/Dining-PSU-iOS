//
//  LocationHours.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/6/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import Foundation

// mm/dd/yyyy

typealias DiningHallHours = [String: [LocationHours]]

struct LocationHours {
    var menuCategoryNumber: String?
    var dayOfWeekStart: Int
    var dayOfWeekEnd: Int?
    var timeOpen: String
    var timeClosed: String
    
    init(from json: [String: Any]) {
        if let s = json["menuCategoryNumber"] as? String {
            menuCategoryNumber = s
        }
        if let s = json["menuCategoryNumber"] as? Int {
            menuCategoryNumber = String(s)
        }
        if let s = json["dayofweekStart"] as? String {
            dayOfWeekStart = Int(s)!
        } else {
            let n = json["dayofweekStart"] as! NSNumber
            dayOfWeekStart = n.intValue
        }
        if let val = json["dayofweekEnd"], !(val is NSNull) {
            if let s = val as? String {
                dayOfWeekEnd = Int(s)!
            } else {
                let n = val as! NSNumber
                dayOfWeekEnd = n.intValue
            }
        }
        let cs: [Character] = [" ", "."]
        timeOpen = (json["timeOpenDisplay"] as! String).filter{!cs.contains($0)}
        timeClosed = (json["timeCloseDisplay"] as! String).filter{!cs.contains($0)}
    }
}
