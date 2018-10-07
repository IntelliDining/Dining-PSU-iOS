//
//  CommonDetailDataSource.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/6/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import Foundation

class CommonDetailDataSource {
    var date: Date = Date()
    var selectedMeal: MealName = .breakfast
    var diningHall: DiningHall
    var menu: Menu = [:]
    
    init(diningHall: DiningHall) {
        self.diningHall = diningHall
    }
    
    func download(completion: @escaping (Result<Bool>) -> Void) {
        
    }
}
