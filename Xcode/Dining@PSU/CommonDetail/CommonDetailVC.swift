//
//  CommonDetailVC.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/6/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import UIKit

class CommonDetailVC: UIViewController {
    
    var datePicker: JZDatepicker = {
        let dP = JZDatepicker(frame: .zero)
        dP.tintColor = UIColor(hexString: "4A3B93")
        return dP
    }()
    
    var diningHall: DiningHall
    
    init(diningHall: DiningHall) {
        self.diningHall = diningHall
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = diningHall.title.replacingOccurrences(of: "\n", with: " ")
    }
    
    func setupViews() {
        view.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.height.equalTo(75)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
