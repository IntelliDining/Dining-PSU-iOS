//
//  CommonDetailDataSource.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/6/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import Foundation

class CommonDetailDataSource {
    var diningHallID: String
    
    var date: Date = Date()
    var selectedMeal: MealName = .breakfast {
        didSet {
            self.filteredLocations = self.filterLocations(mealName: selectedMeal)
        }
    }
    var menu: Menu = [:]
    var filteredLocations: [String] = []
    
    init(diningHallID: String) {
        self.diningHallID = diningHallID
    }
    
    func download(completion: @escaping (Result<Bool>) -> Void) {
        
        /*
        var didError = false
        var errorMessage: String? = nil
        
        let group = DispatchGroup()
        group.enter()
        
        DataService.getLocations(diningHallID: diningHallID) { result in
            switch result {
            case .success(value: let locations):
                self.locations = locations
            case .failure(error: let error):
                errorMessage = error
                didError = true
            }
            group.leave()
        }
 
        
        group.enter()
        */
        DataService.getMenu(date: date, diningHallID: diningHallID) { result in
            switch result {
            case .success(let menu):
                self.menu = menu
                self.filteredLocations = self.filterLocations(mealName: self.selectedMeal)
                completion(Result.success(value: true))
            case .failure(error: let error):
//                didError = true
//                errorMessage = error
                completion(Result.failure(error: error))
            }
            //group.leave()
        }
        
        /*
        group.notify(queue: .main) {
            if didError {
                completion(Result.failure(error: errorMessage ?? "Unknown"))
            } else {
                self.filteredLocations = self.filterLocations(mealName: self.selectedMeal)
                completion(Result.success(value: true))
            }
        }
        */
        
        
    }
    
    func filterLocations(mealName: MealName) -> [String] {
        var locs: [String] = []
        if let locDict = menu[mealName] {
            for (location, items) in locDict {
                if items.count > 0 {
                    locs.append(location)
                }
            }
        }
        return locs
    }
}
