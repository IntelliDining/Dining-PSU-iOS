//
//  CommonDetailViewModel.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/7/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import UIKit

protocol CDViewModelDelegate {
    func selected(menuItem: MenuItem)
}

class CommonDetailViewModel: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var dataSource: CommonDetailDataSource
    var tableView: UITableView
    
    var delegate: CDViewModelDelegate?
    
    init(tableView: UITableView, dataSource: CommonDetailDataSource) {
        self.tableView = tableView
        self.dataSource = dataSource
        
        tableView.register(MenuItemCell.self, forCellReuseIdentifier: "MenuItemCell")
    }
    
    // - MARK: Tableview data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.filteredLocations.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource.filteredLocations[section].menuCategoryName
    }
    
    func getItems(inSection section: Int) -> [MenuItem] {
        let categoryName = dataSource.filteredLocations[section].menuCategoryName
        let items = dataSource.menu[dataSource.selectedMeal]![categoryName]!
        return items
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getItems(inSection: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCell
        let items = getItems(inSection: indexPath.section)
        let item = items[indexPath.row]
        cell.configureWith(item)
        return cell
    }
    
    // - MARK: Tableview height
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    // - MARK: Tableview seleciton
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let items = getItems(inSection: indexPath.section)
        let item = items[indexPath.row]
        delegate?.selected(menuItem: item)
    }
}
