//
//  Location.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/6/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import Foundation

struct Location {
    var menuCategoryNumber: String // Location ID
    var menuCategoryName: String
    var locationNumber: String // Dining Hall ID
    var locationName: String
    
    init(from json: [String: Any]) {
        if let s = json["menuCategoryNumber"] as? String {
            menuCategoryNumber = s
        } else {
            let n = json["menuCategoryNumber"] as! NSNumber
            menuCategoryNumber = n.stringValue
        }
        menuCategoryName = json["menuCategoryName"] as! String
        if let s = json["locationNumber"] as? String {
            locationNumber = s
        } else {
            let n = json["locationNumber"] as! NSNumber
            locationNumber = n.stringValue
        }
        locationName = json["locationName"] as! String
    }
}
