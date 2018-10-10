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
    
    var tableViewEmptyView: UIView?
    
    var delegate: CDViewModelDelegate?
    var selectionEnabled = true
    
    init(tableView: UITableView, dataSource: CommonDetailDataSource) {
        self.tableView = tableView
        self.dataSource = dataSource
        
        tableView.register(MenuItemCell.self, forCellReuseIdentifier: "MenuItemCell")
    }
    
    // - MARK: Tableview data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if dataSource.filteredLocations.count == 0 {
            // Build background view
            if tableViewEmptyView == nil {
                tableViewEmptyView = UIView()
                tableViewEmptyView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                tableView.backgroundView = tableViewEmptyView
                
                let l = UILabel()
                l.textColor = UIColor(hexString: "093162")
                l.text = "No Menu"
                
                tableViewEmptyView!.addSubview(l)
                l.snp.makeConstraints { make in
                    make.centerX.equalTo(tableViewEmptyView!)
                    make.top.equalTo(tableViewEmptyView!).offset(16)
                }
            } else {
                tableView.backgroundView = tableViewEmptyView
            }
        } else {
            tableView.backgroundView = nil
        }
        
        return dataSource.filteredLocations.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource.filteredLocations[section]
    }
    
    func getItems(inSection section: Int) -> [MenuItem] {
        let categoryName = dataSource.filteredLocations[section]
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
        if !selectionEnabled {
            cell.accessoryType = .none
            cell.selectionStyle = .none
        }
        return cell
    }
    
    // - MARK: Tableview height
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    // - MARK: Tableview seleciton
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard selectionEnabled else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        let items = getItems(inSection: indexPath.section)
        let item = items[indexPath.row]
        delegate?.selected(menuItem: item)
    }
}
