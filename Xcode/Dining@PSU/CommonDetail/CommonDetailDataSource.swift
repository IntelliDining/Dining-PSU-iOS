//
//  CommonDetailDataSource.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/6/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import Foundation

class CommonDetailDataSource {
    var diningHall: DiningHall
    
    var date: Date = Date()
    var selectedMeal: MealName = .breakfast {
        didSet {
            refilterLocations()
        }
    }
    var menu: Menu = [:]
    var locations: [Location] = []
    var filteredLocations: [Location] = []
    
    init(diningHall: DiningHall) {
        self.diningHall = diningHall
    }
    
    func download(completion: @escaping (Result<Bool>) -> Void) {
        
        var didError = false
        var errorMessage: String? = nil
        
        let group = DispatchGroup()
        group.enter()
        
        DataService.getLocations(diningHall: diningHall) { result in
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
        DataService.getMenu(date: date, diningHallID: diningHall.id) { result in
            switch result {
            case .success(let menu):
                self.menu = menu
                self.refilterLocations()
            case .failure(error: let error):
                didError = true
                errorMessage = error
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            if didError {
                completion(Result.failure(error: errorMessage ?? "Unknown"))
            } else {
                completion(Result.success(value: true))
            }
        }
    }
    
    func refilterLocations() {
        if let menus = menu[selectedMeal.rawValue] {
            filteredLocations = locations.filter {
                guard let items = menus[$0.locationName] else { return false }
                return items.count > 0
            }
        }
        
    }
}
