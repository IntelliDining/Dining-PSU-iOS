//
//  DiningHallHoursVC.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/10/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import UIKit

class DiningHallHoursVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    lazy var tableView: UITableView = {
        let t = UITableView()
        t.delegate = self
        t.dataSource = self
        t.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        return t
    }()
    lazy var refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.addTarget(self, action: #selector(load), for: .valueChanged)
        return r
    }()
    
    lazy var dataSource = DiningHallHoursDataSource(diningHall: self.diningHall)
    var diningHall: DiningHall
    
    init(diningHall: DiningHall) {
        self.diningHall = diningHall
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = diningHall.title.trimmingCharacters(in: .whitespacesAndNewlines) + " Hours"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        let tableViewController = UITableViewController()
        tableViewController.tableView = tableView
        tableViewController.refreshControl = refreshControl
        addChild(tableViewController)
        
        tableView.tableFooterView = UIView()
        tableView.register(HourCell.self, forCellReuseIdentifier: "HourCell")
        
        load()
    }
    
    @objc func load() {
        startLoadingAnimations()
        dataSource.download { result in
            switch result {
            case .success:
                self.tableView.reloadData()
            case .failure(error: let error):
                let alert = UIAlertController(title: "Failed to load timings", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            self.stopLoadingAnimations()
        }
    }
    
    func startLoadingAnimations() {
        if !refreshControl.isRefreshing {
            tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentOffset.y-refreshControl.frame.size.height),
                                       animated: true)
            refreshControl.beginRefreshing()
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func stopLoadingAnimations() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if refreshControl.isRefreshing {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    // - MARK: UITableView DataSource and Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.locations.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let loc = dataSource.locations[section]
        return loc.menuCategoryName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.hours[section]!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HourCell", for: indexPath) as! HourCell
        let hour = dataSource.hours[indexPath.section]![indexPath.row]
        cell.configure(timing: hour)
        return cell
    }
}
