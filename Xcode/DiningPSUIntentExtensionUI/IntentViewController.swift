//
//  IntentViewController.swift
//  DiningPSUIntentExtensionUI
//
//  Created by Dhruv  Sringari on 10/7/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import IntentsUI
import SnapKit

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    var dataSource: CommonDetailDataSource!
    var tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        t.backgroundColor = .white
        return t
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        return r
    }()
    
    var viewModel: CommonDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
            make.center.equalTo(view)
        }
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
        
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        guard let intent = interaction.intent as? ViewMenuIntent else {
            completion(false, Set(), .zero)
            return
        }
        
        let hall = intent.location!.lowercased()
        
        dataSource = CommonDetailDataSource(diningHallID: ViewMenuIntentHandler.diningHallMap[hall]!)
        dataSource.date = Date()
        dataSource.selectedMeal = ViewMenuIntentHandler.stringToMeal(string: intent.meal!.lowercased())!
        
        viewModel = CommonDetailViewModel(tableView: self.tableView, dataSource: self.dataSource)
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        
        viewModel.selectionEnabled = false
        
        startLoadingAnimations()
        dataSource.download { result in
            if case .success = result {
                self.tableView.reloadData()
            }
            self.stopLoadingAnimations()
        }
        
        completion(true, parameters, self.desiredSize)
    }
    
    var desiredSize: CGSize {
        return self.extensionContext!.hostedViewMaximumAllowedSize
    }
    
}
