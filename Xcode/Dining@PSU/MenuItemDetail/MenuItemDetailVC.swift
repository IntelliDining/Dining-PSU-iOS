//
//  MenuItemDetailVC.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/7/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import UIKit

class MenuItemDetailVC: UIViewController {
    
    var scrollView: UIScrollView = {
        let s = UIScrollView()
        s.isScrollEnabled = true
        return s
    }()
    
    var itemName: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        l.numberOfLines = 0
        return l
    }()
    
    var servingSize: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        l.text = "Serving Size"
        return l
    }()
    
    var servingSizeLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return l
    }()
    
    var calories: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        l.text = "Calories"
        return l
    }()
    
    var caloriesLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return l
    }()
    
    var caloriesFromFatLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        l.textAlignment = .right
        return l
    }()
    
    var totalFat: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        l.text = "Total Fat"
        return l
    }()
    
    var totalFatLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return l
    }()
    
    var saturatedFatLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return l
    }()
    
    var transFatLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return l
    }()
    
    var cholesterol: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        l.text = "Cholesterol"
        return l
    }()
    
    var cholesterolLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return l
    }()
    
    var totalCarbohydrates: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        l.text = "Total Carbohydrates"
        return l
    }()
    
    var totalCarbohydratesLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return l
    }()
    
    var dietaryFiberLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return l
    }()
    
    var sugarsLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return l
    }()
    
    var protein: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        l.text = "Protein"
        return l
    }()
    
    var proteinLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return l
    }()
    
    var ingredients: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        l.text = "Ingredients"
        return l
    }()
    
    var ingredientsLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        l.numberOfLines = 0
        return l
    }()
    
    var alergens: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        l.text = "Allergens"
        return l
    }()
    
    var alergensLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        l.numberOfLines = 0
        return l
    }()
    
    var menuItem: MenuItem
    
    init(menuItem: MenuItem) {
        self.menuItem = menuItem
        super.init(nibName: nil, bundle: nil)
        setupContraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        populate()
        
        navigationItem.title = "Menu Item Info"
    }
    
    func populate() {
        itemName.text = menuItem.recipePrintAsName
        servingSizeLabel.text = menuItem.serviceSize
        caloriesLabel.text = menuItem.calories
        caloriesFromFatLabel.text = "Calories From Fat \(menuItem.caloriesFromFat)"
        totalFatLabel.text = menuItem.totalFat
        saturatedFatLabel.text = "Saturated Fat \(menuItem.satFat)"
        transFatLabel.text = "Trans Fat \(menuItem.transFat)"
        cholesterolLabel.text = menuItem.cholesterol
        totalCarbohydratesLabel.text = menuItem.totalCarb
        dietaryFiberLabel.text = "Dietary Fiber \(menuItem.dietaryFiber)"
        sugarsLabel.text = "Sugars \(menuItem.sugars)"
        proteinLabel.text = menuItem.protein
        ingredientsLabel.text = menuItem.ingredientList
        alergensLabel.text = menuItem.allergens
    }
    
    func setupContraints() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
            make.width.height.equalTo(view)
        }
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.width.equalTo(view)
            make.center.equalTo(scrollView)
            make.edges.equalTo(scrollView)
        }
        
        contentView.addSubview(itemName)
        itemName.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
            make.left.equalTo(contentView).offset(16)
        }
        
        contentView.addSubview(servingSize)
        servingSize.snp.makeConstraints { make in
            make.top.equalTo(itemName.snp.bottom).offset(16)
            make.left.equalTo(contentView).offset(16)
        }
        contentView.addSubview(servingSizeLabel)
        servingSizeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(servingSize)
            make.left.equalTo(servingSize.snp.right).offset(4)
        }
        
        contentView.addSubview(calories)
        calories.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(16)
            make.top.equalTo(servingSize.snp.bottom).offset(8)
        }
        contentView.addSubview(caloriesLabel)
        caloriesLabel.snp.makeConstraints { make in
            make.bottom.equalTo(calories)
            make.left.equalTo(calories.snp.right).offset(4)
        }
        
        contentView.addSubview(caloriesFromFatLabel)
        caloriesFromFatLabel.snp.makeConstraints { make in
            make.bottom.equalTo(calories)
            make.right.equalTo(contentView).offset(-16)
        }
        
        contentView.addSubview(totalFat)
        totalFat.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(16)
            make.top.equalTo(calories.snp.bottom).offset(8)
        }
        contentView.addSubview(totalFatLabel)
        totalFatLabel.snp.makeConstraints { make in
            make.left.equalTo(totalFat.snp.right).offset(4)
            make.bottom.equalTo(totalFat)
        }
        
        contentView.addSubview(saturatedFatLabel)
        saturatedFatLabel.snp.makeConstraints { make in
            make.top.equalTo(totalFat.snp.bottom).offset(8)
            make.left.equalTo(contentView).offset(40)
        }
        contentView.addSubview(transFatLabel)
        transFatLabel.snp.makeConstraints { make in
            make.top.equalTo(saturatedFatLabel.snp.bottom).offset(4)
            make.left.equalTo(contentView).offset(40)
        }
        
        contentView.addSubview(cholesterol)
        cholesterol.snp.makeConstraints { make in
            make.top.equalTo(transFatLabel.snp.bottom).offset(8)
            make.left.equalTo(contentView).offset(16)
        }
        contentView.addSubview(cholesterolLabel)
        cholesterolLabel.snp.makeConstraints { make in
            make.bottom.equalTo(cholesterol)
            make.left.equalTo(cholesterol.snp.right).offset(4)
        }
        
        contentView.addSubview(totalCarbohydrates)
        totalCarbohydrates.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(16)
            make.top.equalTo(cholesterol.snp.bottom).offset(8)
        }
        contentView.addSubview(totalCarbohydratesLabel)
        totalCarbohydratesLabel.snp.makeConstraints { make in
            make.left.equalTo(totalCarbohydrates.snp.right).offset(4)
            make.bottom.equalTo(totalCarbohydrates)
        }
        
        contentView.addSubview(dietaryFiberLabel)
        dietaryFiberLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(40)
            make.top.equalTo(totalCarbohydrates.snp.bottom).offset(8)
        }
        contentView.addSubview(sugarsLabel)
        sugarsLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(40)
            make.top.equalTo(dietaryFiberLabel.snp.bottom).offset(4)
        }
        
        contentView.addSubview(protein)
        protein.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(16)
            make.top.equalTo(sugarsLabel.snp.bottom).offset(8)
        }
        contentView.addSubview(proteinLabel)
        proteinLabel.snp.makeConstraints { make in
            make.left.equalTo(protein.snp.right).offset(4)
            make.bottom.equalTo(protein)
        }
        
        contentView.addSubview(ingredients)
        ingredients.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(16)
            make.top.equalTo(protein.snp.bottom).offset(8)
        }
        contentView.addSubview(ingredientsLabel)
        ingredientsLabel.snp.makeConstraints { make in
            make.top.equalTo(ingredients.snp.bottom).offset(4)
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
        }
        
        contentView.addSubview(alergens)
        alergens.snp.makeConstraints { make in
            make.top.equalTo(ingredientsLabel.snp.bottom).offset(8)
            make.left.equalTo(contentView).offset(16)
        }
        contentView.addSubview(alergensLabel)
        alergensLabel.snp.makeConstraints { make in
            make.top.equalTo(alergens.snp.bottom).offset(4)
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
            make.bottom.lessThanOrEqualTo(contentView).offset(-16)
        }
    }


}
