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
    static let base = "https://api.absecom.psu.edu/rest/"
    
    private static func get<T>(_ endpoint: String, _ data: [String: Any]?, _ completion: @escaping (Result<[T]>) -> Void) {
        let query: String;
        
        if let d = data {
            query = "?" + d.map {key, value in "\(key)=\(value)"}.joined(separator: "&")
        }
        
        else {
            query = "";
        }
        
        Alamofire.request(DataService.base + endpoint + "/v1/221723" + query).responseJSON {response in
            switch (response.result) {
                case .success(let json):
                    let dict = json as! [String: [Any]]
                    
                    print(dict["DATA"]!.self)
                    
                    var zipps: [Zip2Sequence<[String], [Any]>] = []
                    for datum in dict["DATA"]! {
                        let arr = datum as! [Any]
                        let zipped = zip(dict["COLUMNS"] as! [String], arr)
                        zipps.append(zipped)
                    }
                    
                    var objArray: [[String: Any]] = []
                    for zipped in zipps {
                        let dict = Dictionary(uniqueKeysWithValues: zipped)
                        let d = dict as! [String: Any]
                        let r = rename(d)
                        objArray.append(r)
                    }
                    
                    switch (T.self) {
                    case is DiningHall.Type:
                        //                            DiningHall(objDict)
                        break
                    case is Location.Type:
                        break
                    case is LocationHours.Type:
                        break
                    case is MenuItem.Type:
                        break
                    default:
                        completion(Result.failure(error: "Unknown type \(T.self)"))
                    }
                    
                    break
                case .failure(let error):
                    completion(Result.failure(error: error.localizedDescription))
                    break
            }
        }
    }
    
    private static func rename(_ input: [String: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {arg in let (key, value) = arg; return (toCamelCase(key), value)})
    }
    
    private static func toCamelCase(_ input: String) -> String {
        return input.lowercased().split(separator: "_").enumerated().map {arg in let (i, str) = arg; return i > 0 ? String(str.prefix(1)).capitalized + String(str.dropFirst()) : String(str)}.joined(separator: "")
    }
    
    static func getDiningHalls(completion: @escaping (Result<[DiningHall]>) -> Void) {
        get("facilities/areas", nil, completion)
//
//        let e = DiningHall(id: 0,
//                           title: "Findlay\nDining\nCommons",
//                           image: UIImage(named: "findlay")!,
//                           campusCode: "",
//                           latitude: 0.0,
//                           longitude: 0.0)
//
//        let p = DiningHall(id: 1,
//                           title: "Pollock\nDining\nCommons",
//                           image: UIImage(named: "pollock")!,
//                           campusCode: "",
//                           latitude: 0.0,
//                           longitude: 0.0)
//
//        let m = DiningHall(id: 2,
//                           title: "The Mix\nAt\nPollock",
//                           image: UIImage(named: "pollock")!,
//                           campusCode: "",
//                           latitude: 0.0,
//                           longitude: 0.0)
//
//        let s = DiningHall(id: 3,
//                           title: "South\nFood\nDistrict",
//                           image: UIImage(named: "south")!,
//                           campusCode: "",
//                           latitude: 0.0,
//                           longitude: 0.0)
//
//        let w = DiningHall(id: 4,
//                           title: "West\nFood\nDistrict",
//                           image: UIImage(named: "west")!,
//                           campusCode: "",
//                           latitude: 0.0,
//                           longitude: 0.0)
//
//        let n = DiningHall(id: 5,
//                           title: "North\nFood\nDistrict",
//                           image: UIImage(named: "north")!,
//                           campusCode: "",
//                           latitude: 0.0,
//                           longitude: 0.0)
//
//        let diningHalls = [e, p, m, s, w, n]
//        completion(Result.success(value: diningHalls))
    }
    
    static func getHours(completion: @escaping (Result<DiningHallHours>) -> Void) {
        get("facilities/hours", nil) { (result: Result<[LocationHours]>) in
            switch (result) {
            case .success(let data):
                let keys = data.map {datum in datum.menuCategoryNumber}.filter {str in str != nil}
                
                let raw = Dictionary(uniqueKeysWithValues: keys.map {key in (key!, data.filter {datum in datum.menuCategoryNumber == key})})
                
                completion(Result.success(value: raw))
                break
            case .failure(let error):
                completion(Result.failure(error: error))
            }
        }
    }
    
    static func getLocations(diningHall: DiningHall, completion: @escaping (Result<[Location]>) -> Void) {
        get("facilities/locations", ["location": diningHall.id], completion)
    }
    
    // mm/dd/yyyy
    static func getMenu(date: Date, diningHallID: String, completion: @escaping (Result<Menu>) -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm/dd/yyyy"
        let dateString = formatter.string(from: date)
        
        get("services/food/menus", ["date": dateString, "location": diningHallID]) { (result: Result<[MenuItem]>) in
            switch (result) {
            case .success(let data):
                let meals = Array(Set(data.map {$0.mealName}))
                let sections = Array(Set(data.map {$0.menuCategoryName}))
                
                let raw = Dictionary(uniqueKeysWithValues: meals.map {k in (k, Dictionary(uniqueKeysWithValues: sections.map {k1 in (k1, data.filter {datum in datum.mealName == k && datum.menuCategoryName == k1})}))})
                
                completion(Result.success(value: raw))
                break
            case .failure(let error):
                completion(Result.failure(error: error))
            }
        }
    }
    
    
    
}
