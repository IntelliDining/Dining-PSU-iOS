//
//  SelectCommonsVC.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/6/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class SelectCommonsVC: UIViewController, SelectCommonsViewModelDelegate {
    
    var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        let c = UICollectionView(frame: .zero, collectionViewLayout: flow)
        c.backgroundColor = .clear
        c.alwaysBounceVertical = true
        c.delaysContentTouches = false
        c.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        return c
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.addTarget(self, action: #selector(reload), for: .valueChanged)
        return r
    }()
    
    lazy var infoButton: UIBarButtonItem = {
        let b = UIBarButtonItem(image: UIImage(named: "info")!, style: .plain, target: self, action: #selector(openAboutVC))
        return b
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
        navigationItem.rightBarButtonItem = infoButton
        
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        collectionView.addSubview(refreshControl)
        
        getApiKey { self.reload() }
    }
    
    private func getApiKey(_ callback: @escaping () -> Void) {
        Database.database().reference().observeSingleEvent(of: .value, with: { snapshot in
            let data = snapshot.value as? [String : Int] ?? [:]
            
            if let apiKey = data["apiKey"] {
                DataService.apiKey = apiKey
                callback()
            }
                
            else {
                self.showAlert("Invalid response from server", callback: callback)
            }
        }) { (error) in
            self.showAlert(error.localizedDescription, callback: callback)
        }
    }
    
    private func showAlert(_ message: String, callback: @escaping () -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "API Key Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default) {
                action in self.getApiKey(callback)
            })
            self.present(alert, animated: true, completion: nil)
        }
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
    
    @objc func openAboutVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let aboutVC = storyboard.instantiateViewController(withIdentifier: "aboutVC")
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            aboutVC.modalPresentationStyle = .popover
            aboutVC.popoverPresentationController?.barButtonItem = self.infoButton
            self.present(aboutVC, animated: true)
        }
        
        else {
            navigationController?.pushViewController(aboutVC, animated: true)
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
}
