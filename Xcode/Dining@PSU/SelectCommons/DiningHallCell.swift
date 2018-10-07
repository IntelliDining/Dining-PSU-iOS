//
//  DiningHallCell.swift
//  Dining@PSU
//
//  Created by Dhruv  Sringari on 10/6/18.
//  Copyright © 2018 IntelliDining. All rights reserved.
//

import UIKit
import SnapKit

class DiningHallCell: UICollectionViewCell, ShrinkingView {
    var label: UILabel = {
        let l =  UILabel()
        l.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        l.textColor = .white
        l.textAlignment = .left
        l.numberOfLines = 4
        return l
    }()
    
    var imageView: UIImageView = {
        let i = UIImageView()
        i.contentMode = .scaleAspectFill
        i.clipsToBounds = true
        i.backgroundColor = .white
        return i
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius =  8
        contentView.layer.masksToBounds = true
        setupConstraints()
    }
    
    func configureWith(_ diningHall: DiningHall) {
        label.text = diningHall.title.replacingOccurrences(of: " ", with: "\n")
        imageView.image = diningHall.image
    }
    
    func setupConstraints() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(8)
            make.bottom.equalTo(contentView).offset(-8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.applySketchShadow(color: .black, alpha: 0.5,
                                x: 0, y: 2,
                                blur: 4, spread: 0, cornerRadius: 8)
        label.layer.applyTextSketchShadow(color: .black, alpha: 1,
                                      x: 1, y: 2,
                                      blur: 4)
    }
    
}
