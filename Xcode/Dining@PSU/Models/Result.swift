//
//  Result.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/6/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import Foundation

enum Result<T> {
    case failure(error: String)
    case success(value: T)
}
