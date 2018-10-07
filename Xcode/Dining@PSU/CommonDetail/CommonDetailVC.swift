//
//  CommonDetailVC.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/6/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import UIKit

class CommonDetailVC: UIViewController {
    let appTintColor = UIColor(hexString: "093162")
    
    var datePicker: JZDatepicker!
    lazy var segmentedControl: UISegmentedControl = {
        let s = UISegmentedControl(items: ["Breakfast", "Lunch", "Dinner", "Late Night"])
        s.tintColor = appTintColor
        s.selectedSegmentIndex = 0
        return s
    }()
    
    var tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        return t
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.addTarget(self, action: #selector(load), for: .valueChanged)
        return r
    }()
    
    lazy var dataSource = CommonDetailDataSource(diningHall: self.diningHall)
    lazy var viewModel = CommonDetailViewModel(tableView: self.tableView,
                                               dataSource: self.dataSource)
    
    
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
        edgesForExtendedLayout = []
        view.backgroundColor = .white
        navigationItem.title = diningHall.title.replacingOccurrences(of: "\n", with: " ")
        
        let tableViewController = UITableViewController()
        tableViewController.tableView = tableView
        tableViewController.refreshControl = refreshControl
        addChild(tableViewController)
        
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        
        setupViews()
        datePicker.fillCurrentYear()
        datePicker.selectDate(Date())
        
        load()
    }
    
    @objc func load() {
        startLoadingAnimations()
        dataSource.download { result in
            switch result {
            case .success:
                self.tableView.reloadData()
            case .failure(error: let error):
                let alert = UIAlertController(title: "Failed to load menu.", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            self.stopLoadingAnimations()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Disable nav shadow
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Enable nav shadow
        navigationController?.navigationBar.shadowImage = nil
    }
    
    @objc func didPickDate() {
        let date = datePicker.selectedDate!
        dataSource.date = date
        load()
    }
    
    func startLoadingAnimations() {
        tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentOffset.y-refreshControl.frame.size.height),
                                   animated: true)
        refreshControl.beginRefreshing()
    }
    
    func stopLoadingAnimations() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    func setupViews() {
        datePicker = JZDatepicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 60))
        datePicker.tintColor = appTintColor
        view.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(didPickDate), for: .valueChanged)
        datePicker.snp.makeConstraints { make in
            make.left.top.right.equalTo(view)
            make.height.equalTo(60)
            make.width.equalTo(view.snp.width)
        }
        
        let separator = UIView()
        separator.backgroundColor = UIColor(hexString: "979797")
        view.insertSubview(separator, belowSubview: datePicker)
        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(datePicker.snp.bottom).offset(-1)
            make.left.right.equalTo(view)
        }
        
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(16)
            make.top.equalTo(separator.snp.bottom).offset(8)
            make.height.equalTo(33)
        }
    }

}
