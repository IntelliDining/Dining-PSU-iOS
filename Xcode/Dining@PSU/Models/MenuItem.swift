//
//  MenuItem.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/6/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import Foundation

// MealName: //Place:
typealias Menu = [MealName: [String: [MenuItem]]]

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
    
    init(from json: [String: Any]) {
        id = json["id"] as? Int ?? Int(json["id"] as! String)!
        serveDate = json["serveDate"] as! String
        mealNumber = json["mealNumber"] as? Int ?? Int(json["mealNumber"] as! String)!
        mealName = MealName(rawValue: json["mealName"] as! String) ?? .breakfast
        locationNumber = json["locationNumber"] as? Int ?? Int(json["locationNumber"] as! String)!
        locationName = json["locationName"] as! String
        menuCategoryNumber = json["menuCategoryNumber"] as? Int ?? Int(json["menuCategoryNumber"] as! String)!
        menuCategoryName = json["menuCategoryName"] as! String
        recipeNumber = json["recipeNumber"] as? Int ?? Int(json["recipeNumber"] as! String)!
        recipeName = json["recipeName"] as! String
        recipePrintAsName = json["recipePrintAsName"] as! String
        ingredientList = json["ingredientList"] as! String
        allergens = json["allergens"] as! String
        recipePrintAsColor = json["recipePrintAsColor"] as? String ?? ""
        recipePrintAsCharacter = json["recipePrintAsCharacter"] as! String
        recipeProductInformation = json["recipeProductInformation"] as! String
        sellingPrice = json["sellingPrice"] as? String ?? ""
        portionCost = json["portionCost"] as? String ?? ""
        productionDepartment = json["mealNumber"] as? String ?? String(json["mealNumber"] as! Int)
        serviceDepartment = json["serviceDepartment"] as? String ?? String(json["serviceDepartment"] as! Int)
        cateringDepartment = json["serviceDepartment"] as? String ?? String(json["serviceDepartment"] as! Int)
        recipeWebCodes = json["recipeWebCodes"] as! String
        serviceSize = json["serviceSize"] as? String ?? ""
        calories = json["calories"] as? String ?? String(json["calories"] as! Int)
        caloriesFromFat = json["caloriesFromFat"] as? String ?? String(json["caloriesFromFat"] as! Int)
        totalFat = json["totalFat"] as? String ?? String(json["totalFat"] as! Int)
        totalFatDv = json["totalFatDv"] as? String ?? String(json["totalFatDv"] as! Int)
        satFat = json["satFat"] as? String ?? String(json["satFat"] as! Int)
        satFatDv = json["satFatDv"] as? String ?? String(json["satFatDv"] as! Int)
        transFat = json["transFat"] as? String ?? String(json["transFat"] as! Int)
        transFatDv = json["transFatDv"] as? String ?? String(json["transFatDv"] as! Int)
        cholesterol = json["cholesterol"] as? String ?? String(json["cholesterol"] as! Int)
        cholesterolDv = json["cholesterolDv"] as? String ?? String(json["cholesterolDv"] as! Int)
        sodium = json["sodium"] as? String ?? String(json["sodium"] as! Int)
        sodiumDv = json["sodiumDv"] as? String ?? String(json["sodiumDv"] as! Int)
        totalCarb = json["totalCarb"] as? String ?? String(json["totalCarb"] as! Int)
        totalCarbDv = json["totalCarbDv"] as? String ?? String(json["totalCarbDv"] as! Int)
        dietaryFiber = json["dietaryFiber"] as? String ?? String(json["dietaryFiber"] as! Int)
        dietaryFiberDv = json["dietaryFiberDv"] as? String ?? String(json["dietaryFiberDv"] as! Int)
        sugars = json["sugars"] as? String ?? String(json["sugars"] as! Int)
        sugarsDv = json["sugarsDv"] as? String ?? String(json["sugarsDv"] as! Int)
        protein = json["protein"] as? String ?? String(json["protein"] as! Int)
        proteinDv = json["proteinDv"] as? String ?? String(json["proteinDv"] as! Int)
    }
}
