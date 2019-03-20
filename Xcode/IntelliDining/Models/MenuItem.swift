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
    var serveDate: String?
    var mealNumber: Int
    var mealName: MealName
    var locationNumber: Int
    var locationName: String
    var menuCategoryNumber: Int
    var menuCategoryName: String
    var recipeNumber: Int
    var recipeName: String?
    var recipePrintAsName: String?
    var ingredientList: String?
    var allergens: String?
    var recipePrintAsColor: String?
    var recipePrintAsCharacter: String?
    var recipeProductInformation: String?
    var sellingPrice: String?
    var portionCost: String?
    var recipeWebCodes: String?
    var serviceSize: String?
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
    
    init(from json: [String: Any]) throws {
        id = try shouldBeInt(json["id"])
        serveDate = canBeString(json["serveDate"])
        mealNumber =  try shouldBeInt(json["mealNumber"])
        mealName = MealName(rawValue: try shouldBeString(json["mealName"])) ?? .breakfast
        locationNumber = try shouldBeInt(json["locationNumber"])
        locationName = try shouldBeString(json["locationName"])

        menuCategoryNumber = canBeInt(json["menuCategoryNumber"]) ?? 0
        menuCategoryName = try shouldBeString(json["menuCategoryName"])
        recipeNumber = try shouldBeInt(json["recipeNumber"])
        recipeName = canBeString(json["recipeName"])
        recipePrintAsName = canBeString(json["recipePrintAsName"])
        ingredientList = canBeString(json["ingredientList"])
        allergens = canBeString(json["allergens"])
        recipePrintAsColor = canBeString(json["recipePrintAsColor"])
        recipePrintAsCharacter = canBeString(json["recipePrintAsColor"])
        recipeProductInformation = canBeString(json["recipeProductInformation"])
        sellingPrice = canBeString(json["sellingPrice"])
        portionCost = canBeString(json["portionCost"])
        recipeWebCodes = canBeString(json["recipeWebCodes"])
        serviceSize = canBeString(json["serviceSize"])
        calories = try shouldBeString(json["calories"])
        caloriesFromFat = try shouldBeString(json["caloriesFromFat"])
        totalFat = try shouldBeString(json["totalFat"])
        totalFatDv = try shouldBeString(json["totalFatDv"])
        satFat = try shouldBeString(json["satFat"])
        satFatDv = try shouldBeString(json["satFatDv"])
        transFat = try shouldBeString(json["transFat"])
        transFatDv = try shouldBeString(json["transFatDv"])
        cholesterol = try shouldBeString(json["cholesterol"])
        cholesterolDv = try shouldBeString(json["cholesterolDv"])
        sodium = try shouldBeString(json["sodium"])
        sodiumDv = try shouldBeString(json["sodiumDv"])
        totalCarb = try shouldBeString(json["totalCarb"])
        totalCarbDv = try shouldBeString(json["totalCarbDv"])
        dietaryFiber = try shouldBeString(json["dietaryFiber"])
        dietaryFiberDv = try shouldBeString(json["dietaryFiberDv"])
        sugars = try shouldBeString(json["sugars"])
        sugarsDv = try shouldBeString(json["sugarsDv"])
        protein = try shouldBeString(json["protein"])
        proteinDv = try shouldBeString(json["proteinDv"])
    }
}

enum MenuParseError: Error {
    case jsonParseError
    case fieldNull
}

func shouldBeInt(_ value: Any?) throws -> Int {
    guard let value = value else {
        throw MenuParseError.fieldNull
    }

    if let i = value as? Int {
        return i
    }

    if let s = value as? String, let i = Int(s) {
        return i
    }

    throw MenuParseError.jsonParseError
}

func shouldBeString(_ value: Any?) throws -> String {
    guard let value = value else {
        throw MenuParseError.fieldNull
    }

    if let s = value as? String {
        return s
    }

    if let i = value as? Int {
        return String(i)
    }

    throw MenuParseError.jsonParseError
}

func canBeInt(_ value: Any?) -> Int? {
    return try? shouldBeInt(value)
}

func canBeString(_ value: Any?) -> String? {
    return try? shouldBeString(value)
}
