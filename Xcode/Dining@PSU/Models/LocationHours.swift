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
        menuCategoryNumber = json["menuCategoryNumber"] as? String
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
        timeOpen = json["timeOpenDisplay"] as! String
        timeClosed = json["timeCloseDisplay"] as! String
    }
}
