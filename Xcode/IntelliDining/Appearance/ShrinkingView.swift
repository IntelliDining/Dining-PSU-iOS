//
//  ShrinkingCell.swift
//  SmartPass
//
//  Created by Dhruv  Sringari on 6/30/18.
//  Copyright © 2018 Dhruv Sringari. All rights reserved.
//

import UIKit

protocol ShrinkingView: AnyObject {
    func shrink()
    func unshrink()
    func setSelectedBackground()
    func setNormalBackground()
}

extension ShrinkingView {
    func setSelectedBackground() {

    }
    
    func setNormalBackground() {
        
    }
}

extension ShrinkingView where Self: UIView {
    func shrink() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.setSelectedBackground()
        }
    }
    
    func unshrink() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform.identity
            self.setNormalBackground()
        }
    }
}
