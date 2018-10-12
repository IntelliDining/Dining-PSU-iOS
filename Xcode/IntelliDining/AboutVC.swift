//
//  AboutVC.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/10/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {
    
    @IBOutlet var versionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
        
        versionLabel.text = "Version \(version) (\(build))"
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
