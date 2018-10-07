//
//  DataService.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/6/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import Foundation
import Alamofire

class DataService {
    
    static func getDiningHalls(completion: @escaping (Result<[DiningHall]>) -> Void) {
        let e = DiningHall(id: 0,
                           title: "Findlay\nDining\nCommons",
                           image: UIImage(named: "findlay")!,
                           campusCode: "",
                           latitude: 0.0,
                           longitude: 0.0)
        
        let p = DiningHall(id: 1,
                           title: "Pollock\nDining\nCommons",
                           image: UIImage(named: "pollock")!,
                           campusCode: "",
                           latitude: 0.0,
                           longitude: 0.0)
        
        let m = DiningHall(id: 2,
                           title: "The Mix\nAt\nPollock",
                           image: UIImage(named: "pollock")!,
                           campusCode: "",
                           latitude: 0.0,
                           longitude: 0.0)
        
        let s = DiningHall(id: 3,
                           title: "South\nFood\nDistrict",
                           image: UIImage(named: "south")!,
                           campusCode: "",
                           latitude: 0.0,
                           longitude: 0.0)
        
        let w = DiningHall(id: 4,
                           title: "West\nFood\nDistrict",
                           image: UIImage(named: "west")!,
                           campusCode: "",
                           latitude: 0.0,
                           longitude: 0.0)
        
        let n = DiningHall(id: 5,
                           title: "North\nFood\nDistrict",
                           image: UIImage(named: "north")!,
                           campusCode: "",
                           latitude: 0.0,
                           longitude: 0.0)
        
        let diningHalls = [e, p, m, s, w, n]
        completion(Result.success(value: diningHalls))
    }
    
    static func getHours(completion: @escaping (Result<DiningHallHours>) -> Void) {
        completion(Result.success(value: [:]))
    }
    
    static func getLocations(diningHall: DiningHall, completion: @escaping (Result<[Location]>) -> Void) {
        completion(Result.success(value: []))
    }
    
    // mm/dd/yyyy
    static func getMenu(date: Date, diningHallID: Int, completion: @escaping (Result<Menu>) -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm/dd/yyyy"
        let dateString = formatter.string(from: date)
        
        completion(Result.success(value: [:]))
    }
    
    
    
}
