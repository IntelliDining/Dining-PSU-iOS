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
    
    func getDiningHalls(completion: @escaping (Result<[DiningHall]>) -> Void) {
        let e = DiningHall(title: "Findlay\nDining\nCommons",
                           image: UIImage(named: "findlay")!,
                           campusCode: "",
                           latitude: 0.0,
                           longitude: 0.0)
        
        let p = DiningHall(title: "Pollock\nDining\nCommons",
                           image: UIImage(named: "pollock")!,
                           campusCode: "",
                           latitude: 0.0,
                           longitude: 0.0)
        
        let m = DiningHall(title: "The Mix\nAt\nPollock",
                           image: UIImage(named: "pollock")!,
                           campusCode: "",
                           latitude: 0.0,
                           longitude: 0.0)
        
        let s = DiningHall(title: "South\nFood\nDistrict",
                           image: UIImage(named: "south")!,
                           campusCode: "",
                           latitude: 0.0,
                           longitude: 0.0)
        
        let w = DiningHall(title: "West\nFood\nDistrict",
                           image: UIImage(named: "west")!,
                           campusCode: "",
                           latitude: 0.0,
                           longitude: 0.0)
        
        let n = DiningHall(title: "North\nFood\nDistrict",
                           image: UIImage(named: "north")!,
                           campusCode: "",
                           latitude: 0.0,
                           longitude: 0.0)
        
        let diningHalls = [e, p, m, s, w, n]
        completion(Result.success(value: diningHalls))
    }
    
    func getHours(completion: @escaping (Result<DiningHallHours>) -> Void) {
        completion(Result.success(value: [:]))
    }
    
    func getLocations(diningHall: DiningHall, completion: @escaping (Result<[Location]>) -> Void) {
        completion(Result.success(value: []))
    }
    
    // mm/dd/yyyy
    func getMenu(date: Date, location: String, completion: @escaping (Result<Menu>) -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm/dd/yyyy"
        let dateString = formatter.string(from: date)
        
        completion(Result.success(value: [:]))
    }
    
    
    
}
