//
//  DiningHall.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/6/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import UIKit

struct DiningHall {
    var id: String
    var title: String
    var image: UIImage?
    var campusCode: String
    var latitude: Double
    var longitude: Double
    var siriName: String = ""
    
    init(from json: [String: Any]) {
        if let s = json["locationNumber"] as? String {
            id = s
        } else {
            let n = json["locationNumber"] as! NSNumber
            id = n.stringValue
        }
        title = json["locationName"] as! String
        if title == "West Food District" {
            print("pause")
        }
        campusCode = json["campusCode"] as! String
        if let s = json["geoLocationLong"] as? String {
            longitude = Double(s)!
        } else {
            let n = json["geoLocationLong"] as! NSNumber
            longitude = n.doubleValue
        }
        if let s = json["geoLocataionLat"] as? String {
            latitude = Double(s)!
        } else {
            let n = json["geoLocataionLat"] as! NSNumber
            latitude = n.doubleValue
        }
        
        switch id {
        case "11":
            image = UIImage(named: "findlay")!
            siriName = "Findlay"
        case "14":
            image = UIImage(named: "pollock")!
            siriName = "Pollock"
        case "24":
            image = UIImage(named: "the-mix")!
            siriName = "The Mix"
        case "13":
            image = UIImage(named:  "south")!
            siriName = "South"
        case "16":
            image = UIImage(named: "west")!
            siriName = "West"
        case "17":
            image = UIImage(named: "north")!
            siriName = "North"
        default:
            break
        }
    }
}
