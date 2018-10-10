//
//  CommonDetailVC.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/6/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import UIKit

class CommonDetailVC: UIViewController, CDViewModelDelegate {
    
    let appTintColor = UIColor(hexString: "093162")
    
    var datePicker: JZDatepicker!
    lazy var segmentedControl: UISegmentedControl = {
        let s = UISegmentedControl(items: ["Breakfast", "Lunch", "Dinner", "Late Night"])
        s.tintColor = appTintColor
        s.selectedSegmentIndex = 0
        s.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        return s
    }()
    
    var tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        t.backgroundColor = .white
        t.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        return t
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.addTarget(self, action: #selector(load), for: .valueChanged)
        return r
    }()
    
    lazy var dataSource = CommonDetailDataSource(diningHallID: self.diningHall.id)
    lazy var viewModel = CommonDetailViewModel(tableView: self.tableView,
                                               dataSource: self.dataSource)
    
    lazy var infoButton: UIBarButtonItem = {
        let b = UIBarButtonItem(image: UIImage(named: "infoclock")!, style: .plain, target: self, action: #selector(openInfo))
        return b
    }()
    
    
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
        navigationItem.rightBarButtonItem = infoButton
        
        let tableViewController = UITableViewController()
        tableViewController.tableView = tableView
        tableViewController.refreshControl = refreshControl
        addChild(tableViewController)
        
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        tableView.tableFooterView = UIView()
        
        viewModel.delegate = self
        
        setupViews()
        datePicker.fillCurrentYear()
        datePicker.selectDate(Date())
        
        load()
    }
    
    @objc func load() {
        //self.tableView.contentOffset = CGPoint(x: 0, y: 0)
        startLoadingAnimations()
        dataSource.download { result in
            switch result {
            case .success:
                self.validateSegmentedControl()
                self.tableView.reloadData()
            case .failure(error: let error):
                let alert = UIAlertController(title: "Failed to load menu.", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            self.stopLoadingAnimations()
        }
    }
    
    func validateSegmentedControl() {
        
        var disabledCount = 0
        
        if dataSource.filterLocations(mealName: .breakfast).count == 0 {
            segmentedControl.setEnabled(false, forSegmentAt: 0)
            disabledCount += 1
        } else {
            segmentedControl.setEnabled(true, forSegmentAt: 0)
        }
        
        if dataSource.filterLocations(mealName: .lunch).count == 0 {
            segmentedControl.setEnabled(false, forSegmentAt: 1)
            disabledCount += 1
        } else {
            segmentedControl.setEnabled(true, forSegmentAt: 1)
        }
        
        if dataSource.filterLocations(mealName: .dinner).count == 0 {
            segmentedControl.setEnabled(false, forSegmentAt: 2)
            disabledCount += 1
        } else {
            segmentedControl.setEnabled(true, forSegmentAt: 2)
        }
        
        if dataSource.filterLocations(mealName: .fourthMeal).count == 0 {
            segmentedControl.setEnabled(false, forSegmentAt: 3)
            disabledCount += 1
        } else {
            segmentedControl.setEnabled(true, forSegmentAt: 3)
        }
        
        if disabledCount == 4 {
            segmentedControlChanged()
            return
        }
        
        if segmentedControl.selectedSegmentIndex == UISegmentedControl.noSegment || !segmentedControl.isEnabledForSegment(at: segmentedControl.selectedSegmentIndex) {
            segmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
            for i in 0...3 {
                if segmentedControl.isEnabledForSegment(at: i){
                    segmentedControl.selectedSegmentIndex = i
                    segmentedControlChanged()
                    break
                }
            }
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
        if let date = datePicker.selectedDate {
            dataSource.date = date
            load()
        }
    }
    
    @objc func segmentedControlChanged() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            dataSource.selectedMeal = .breakfast
        case 1:
            dataSource.selectedMeal = .lunch
        case 2:
            dataSource.selectedMeal = .dinner
        case 3:
            dataSource.selectedMeal = .fourthMeal
        default:
            dataSource.selectedMeal = .none
        }
        self.tableView.contentOffset = CGPoint(x: 0, y: 0)
        tableView.reloadData()
    }
    
    func selected(menuItem: MenuItem) {
        let detail = MenuItemDetailVC(menuItem: menuItem)
        navigationController?.pushViewController(detail, animated: true)
    }
    
    @objc func openInfo() {
        let vc = DiningHallHoursVC(diningHall: self.diningHall)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func startLoadingAnimations() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentOffset.y-refreshControl.frame.size.height),
                                   animated: true)
        refreshControl.beginRefreshing()
    }
    
    func stopLoadingAnimations() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if refreshControl.isRefreshing {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
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
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(8)
            make.left.right.bottom.equalTo(view)
        }
    }

}
