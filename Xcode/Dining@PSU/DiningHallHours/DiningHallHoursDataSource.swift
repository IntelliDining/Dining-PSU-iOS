//
//  DiningHallHoursDataSource.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/10/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import Foundation

class DiningHallHoursDataSource {
    var diningHall: DiningHall
    var locations: [Location] = []
    var hours: [Int: [LocationHours]] = [:]
    private var allHours: [String: [LocationHours]] = [:]
    
    init(diningHall: DiningHall) {
        self.diningHall = diningHall
    }
    
    func download(completion: @escaping (Result<Bool>) -> Void) {
        let group = DispatchGroup()
        var didError  = false
        var groupError: String!
        
        group.enter()
        DataService.getLocations(diningHallID: diningHall.id) { result in
            switch result {
            case .success(value: let locations):
                self.locations = locations
            case .failure(error: let error):
                didError = true
                groupError = error
            }
            group.leave()
        }
        
        group.enter()
        DataService.getHours { result in
            switch result {
            case .success(value: let hours):
                self.allHours = hours
            case .failure(error: let error):
                didError = true
                groupError = error
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            guard !didError else {
                completion(Result.failure(error: groupError))
                return
            }
            
            self.locations = self.locations.filter{self.allHours[$0.menuCategoryNumber] != nil}
            
            for (i, loc) in self.locations.enumerated() {
                var hours = self.allHours[loc.menuCategoryNumber]
                hours = hours?.sorted{$0.dayOfWeekStart < $1.dayOfWeekStart}
                self.hours[i] = hours
            }
            
            completion(Result.success(value: true))
        }
    }
}
