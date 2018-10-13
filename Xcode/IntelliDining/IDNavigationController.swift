//
//  IDNavigationController.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/6/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import UIKit
//import GoogleMobileAds

class IDNavigationController: UINavigationController {
    
    //var bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    
    var gradientBackground = UIView()
    init() {
        super.init(nibName: nil, bundle: nil)
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.isTranslucent = true
        navigationBar.tintColor = .white
        navigationBar.backgroundColor = .clear
        navigationBar.barStyle = .blackTranslucent
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.titleTextAttributes = textAttributes
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        //setupAds()
    }
    
    /*
    func setupAds() {
        view.addSubview(bannerView)
        bannerView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaInsets.bottom)
            } else {
                make.bottom.equalTo(view.snp.bottom)
            }
            make.centerX.equalTo(view)
        }
        
        bannerView.adUnitID = "ca-app-pub-9355707484240783/9178090758"
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.alpha = 0
        bannerView.isHidden = true
        bannerView.load(GADRequest())
    }
    */
    
    func setupGradient() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let height = statusBarHeight + navigationBar.frame.height
        let bounds = CGRect(x: 0, y: -statusBarHeight, width: navigationBar.frame.width, height: height)
        
        gradientBackground.backgroundColor = .white
        gradientBackground.isUserInteractionEnabled = false
        gradientBackground.frame = bounds
        gradientBackground.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        navigationBar.insertSubview(gradientBackground, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationBar.sendSubviewToBack(gradientBackground)
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientBackground.applyGradient(withColours: [UIColor.gradient1,
                                                       UIColor.gradient2],
                                         gradientOrientation: .horizontal)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        navigationBar.sendSubviewToBack(gradientBackground)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        navigationBar.sendSubviewToBack(gradientBackground)
        return super.popViewController(animated: animated)
    }
    
    /*
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        bannerView.isHidden = false
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
    */

}
