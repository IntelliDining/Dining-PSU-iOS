//
//  MenuItem.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/6/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import Foundation

// MealName: //Place:
typealias Menu = [String: [String: [MenuItem]]]

struct MenuItem {
    var id: Int
    var serveDate: String
    var mealNumber: Int
    var mealName: MealName
    var locationNumber: Int
    var locationName: String
    var menuCategoryNumber: Int
    var menuCategoryName: String
    var recipeNumber: Int
    var recipeName: String
    var recipePrintAsName: String
    var ingredientList: String
    var allergens: String
    var recipePrintAsColor: String
    var recipePrintAsCharacter: String
    var recipeProductInformation: String
    var sellingPrice: String
    var portionCost: String
    var productionDepartment: String
    var serviceDepartment: String
    var cateringDepartment: String
    var recipeWebCodes: String
    var serviceSize: String
    var calories: String
    var caloriesFromFat: String
    var totalFat: String
    var totalFatDv: String
    var satFat: String
    var satFatDv: String
    var transFat: String
    var transFatDv: String
    var cholesterol: String
    var cholesterolDv: String
    var sodium: String
    var sodiumDv: String
    var totalCarb: String
    var totalCarbDv: String
    var dietaryFiber: String
    var dietaryFiberDv: String
    var sugars: String
    var sugarsDv: String
    var protein: String
    var proteinDv: String
}
