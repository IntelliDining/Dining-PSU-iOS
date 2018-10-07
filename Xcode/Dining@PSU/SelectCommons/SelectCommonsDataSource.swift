//
//  SelectCommonsDataSource.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/6/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import UIKit

class SelectCommonsDataSource {
    var diningHalls: [DiningHall] = []
    
    func download(completion: @escaping (Result<Bool>) -> Void) {
        DataService.getDiningHalls { result in
            switch result {
            case .success(value: let diningHalls):
                self.diningHalls = diningHalls
                completion(Result.success(value: true))
            case .failure(error: let errorMessage):
                completion(Result.failure(error: errorMessage))
            }
        }
    }
    
}
