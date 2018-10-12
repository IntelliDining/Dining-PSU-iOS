//
//  Shadow.swift
//  SmartPass
//
//  Created by Dhruv  Sringari on 6/16/18.
//  Copyright © 2018 Dhruv Sringari. All rights reserved.
//

import UIKit

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0,
        cornerRadius: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        let dx = -spread
        let rect = bounds.insetBy(dx: dx, dy: dx)
        shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        shouldRasterize = true
        rasterizationScale = UIScreen.main.scale
    }
    
    func applyTextSketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        masksToBounds = false
    }
}
