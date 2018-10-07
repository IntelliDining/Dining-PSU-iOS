//
//  LocationHours.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/6/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import Foundation

// mm/dd/yyyy

typealias DiningHallHours = [Int: LocationHours]

struct LocationHours {
    var dayOfWeekStart: Int
    var dayOfWeekEnd: Int?
    var timeOpen: String
    var timeClosed: String
}
