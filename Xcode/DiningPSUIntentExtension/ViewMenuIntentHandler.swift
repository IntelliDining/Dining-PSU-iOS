//
//  ViewMenuIntentHandler.swift
//  DiningPSUIntentExtension
//
//  Created by Dhruv  Sringari on 10/7/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import Foundation

class ViewMenuIntentHandler: NSObject, ViewMenuIntentHandling {
    static var diningHallMap = ["findlay": "11", "east": "11",
                                "pollock": "14",
                                "mix": "24", "the mix": "24",
                                "south": "13", "redifer": "13",
                                "west": "16",
                                "north": "17"]
    
    func confirm(intent: ViewMenuIntent, completion: @escaping (ViewMenuIntentResponse) -> Void) {
        guard let location = intent.location?.lowercased() else {
            completion(ViewMenuIntentResponse(code: .failure, userActivity: nil))
            return
        }
        
        guard let meal = intent.meal?.lowercased() else {
            completion(ViewMenuIntentResponse(code: .failure, userActivity: nil))
            return
        }
        
        guard let hallID = ViewMenuIntentHandler.diningHallMap[location] else {
            completion(.invalidLocation(location))
            return
        }
        
        guard let mealName = ViewMenuIntentHandler.stringToMeal(string: meal) else {
            completion(.invalidMeal(meal))
            return
        }
        
        DataService.getMenu(date: Date(), diningHallID: hallID) { result in
            switch result {
            case .success(value: let menu):
                if let locationsDict = menu[mealName] {
                    var empty = true
                    for (_, items) in locationsDict {
                        if items.count > 0 { empty = false }
                    }
                   
                    if !empty {
                        completion(ViewMenuIntentResponse(code: .success, userActivity: nil))
                        return
                    }
                }
                
                completion(.notAtLocation(meal: mealName.rawValue, location: location))
            case .failure(error: _):
                completion(ViewMenuIntentResponse(code: .failure, userActivity: nil))
            }
        }
    }
    
    static func stringToMeal(string: String) -> MealName? {
        if let raw = MealName(rawValue: string) {
            return raw
        }
        
        var mealName: MealName = .breakfast
        switch string {
        case "breakfast":
            mealName = .breakfast
        case "lunch":
            mealName = .lunch
        case "dinner":
            mealName = .dinner
        case "fourth meal", "late night":
            mealName = .fourthMeal
        default:
            return nil
        }
        return mealName
    }
    
    func handle(intent: ViewMenuIntent, completion: @escaping (ViewMenuIntentResponse) -> Void) {
        let meal = ViewMenuIntentHandler.stringToMeal(string: intent.meal!)!
        completion(ViewMenuIntentResponse.success(meal: meal.rawValue, location: intent.location!))
    }
}
