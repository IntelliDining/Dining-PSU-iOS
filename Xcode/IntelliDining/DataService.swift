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

        let params: [String: Any] = [
            "apikey": 1
        ]

        Alamofire.request(DataService.base + endpoint + "/v1/221723" + query, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in
            switch (response.result) {
            case .success(let json):
                let dict = json as! [String: [Any]]

                var zipps: [Zip2Sequence<[String], [Any]>] = []
                for datum in dict["DATA"]! {
                    let arr = datum as! [Any]
                    let zipped = zip(dict["COLUMNS"] as! [String], arr)
                    zipps.append(zipped)
                }

                var objArray: [[String: Any]] = []
                for zipped in zipps {
                    let dict = Dictionary(uniqueKeysWithValues: zipped)
                    let r = rename(dict)
                    objArray.append(r)
                }

                switch (T.self) {
                case is DiningHall.Type:
                    var halls = objArray.map{DiningHall(from: $0)}
                    halls = halls.filter {$0.campusCode == "UP"} // Filter Only University Park Commons
                    completion(Result.success(value: halls as! [T]))
                case is Location.Type:
                    let locations = objArray.map{Location(from: $0)}
                    completion(Result.success(value: locations as! [T]))
                case is LocationHours.Type:
                    let hours = objArray.map{LocationHours(from: $0)}
                    completion(Result.success(value: hours as! [T]))
                case is MenuItem.Type:
                    let items = objArray.compactMap { try? MenuItem(from: $0) }
                    completion(Result.success(value: items as! [T]))
                default:
                    completion(Result.failure(error: "Unknown type \(T.self)"))
                }

                break
            case .failure(let error):
                if let aError = error as? AFError, aError.isResponseValidationError {
                    if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                        completion(Result.failure(error: errorMessage))
                        return
                    }
                }

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
    }
    
    static func getHours(completion: @escaping (Result<DiningHallHours>) -> Void) {
        get("facilities/hours", nil) { (result: Result<[LocationHours]>) in
            switch (result) {
            case .success(let data):
                let keys = data.compactMap{datum in datum.menuCategoryNumber}
                let sKeys = Set(keys)
                
                let raw = Dictionary(uniqueKeysWithValues: sKeys.map { key in
                        (key, data.filter {datum in datum.menuCategoryNumber == key})
                    }
                )
                
                completion(Result.success(value: raw))
                break
            case .failure(let error):
                completion(Result.failure(error: error))
            }
        }
    }
    
    static func getLocations(diningHallID: String, completion: @escaping (Result<[Location]>) -> Void) {
        get("facilities/locations", ["location": diningHallID], completion)
    }
    
    // mm/dd/yyyy
    static func getMenu(date: Date, diningHallID: String, completion: @escaping (Result<Menu>) -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM'/'dd'/'yyyy"
        let dateString = formatter.string(from: date)
        
        get("services/food/menus", ["date": dateString, "location": diningHallID]) { (result: Result<[MenuItem]>) in
            switch (result) {
            case .success(let data):
                let meals = Array(Set(data.map {$0.mealName}))
                print(meals)
                
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
