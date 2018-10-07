//
//  SelectCommonsVC.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/6/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import UIKit
import SnapKit

class SelectCommonsVC: UIViewController, SelectCommonsViewModelDelegate {
    
    
    var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        let c = UICollectionView(frame: .zero, collectionViewLayout: flow)
        c.backgroundColor = .clear
        c.alwaysBounceVertical = true
        c.delaysContentTouches = false
        return c
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.addTarget(self, action: #selector(reload), for: .valueChanged)
        return r
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    var dataSource: SelectCommonsDataSource = SelectCommonsDataSource()
    lazy var viewModel = SelectCommonsViewModel(collectionView: self.collectionView,
                                                viewController: self,
                                                data: self.dataSource)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupContraints()
        
        viewModel.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = .white
        navigationItem.title = "Dining Commons"
        
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        collectionView.addSubview(refreshControl)
        
        reload()
    }
    
    @objc func reload() {
        startLoadingAnimations()
        dataSource.download { result in
            switch result {
            case .success:
                self.collectionView.reloadData()
            case .failure(error: let error):
                let alert = UIAlertController(title: "Failed to load dining commons.", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            self.stopLoadingAnimations()
        }
    }
    
    func setupContraints() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    func selected(diningHall: DiningHall) {
        let detail = CommonDetailVC(diningHall: diningHall)
        navigationController?.pushViewController(detail, animated: true)
    }
    
    func startLoadingAnimations() {
        collectionView.setContentOffset(CGPoint(x: 0, y: collectionView.contentOffset.y-refreshControl.frame.size.height), animated: true)
        refreshControl.beginRefreshing()
    }
    
    func stopLoadingAnimations() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }

}
