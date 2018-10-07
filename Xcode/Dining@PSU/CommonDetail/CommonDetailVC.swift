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
        
        setupViews()
        datePicker.fillCurrentYear()
        datePicker.selectDate(Date())
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
        let date = datePicker.selectedDate
        
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
