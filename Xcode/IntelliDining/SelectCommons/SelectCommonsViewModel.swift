//
//  SelectCommonsViewModel.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/6/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import UIKit

protocol SelectCommonsViewModelDelegate {
    func selected(diningHall: DiningHall)
}

class SelectCommonsViewModel: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    
    var dataSource: SelectCommonsDataSource
    var collectionView: UICollectionView
    var viewController: UIViewController
    var delegate: SelectCommonsViewModelDelegate?
    
    init(collectionView: UICollectionView, viewController: UIViewController, data: SelectCommonsDataSource) {
        self.dataSource = data
        self.viewController = viewController
        self.collectionView = collectionView
        
        collectionView.register(DiningHallCell.self, forCellWithReuseIdentifier: "DiningHallCell")
    }
    
    // - MARK: Collection View Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.diningHalls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiningHallCell", for: indexPath) as! DiningHallCell
        let area = dataSource.diningHalls[indexPath.row]
        cell.configureWith(area)
        return cell
    }
    
    // - Mark: Collection View Sizing
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let view = viewController.view!
        let padding: CGFloat = 16*3
        let availableWidth = view.frame.width - padding
        let widthPerItem = availableWidth / 2
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    // - Mark: Handling Selection
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hall = dataSource.diningHalls[indexPath.row]
        delegate?.selected(diningHall: hall)
    }
    
    // - MARK: Animating Selection
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ShrinkingView {
            cell.shrink()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ShrinkingView {
            cell.unshrink()
        }
    }
}
