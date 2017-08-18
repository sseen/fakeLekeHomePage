//
//  RDHomeCollectionViewCell.swift
//  fakeLekeHomePage
//
//  Created by sseen on 2017/7/4.
//  Copyright © 2017年 sseen. All rights reserved.
//

import UIKit

class RDHomeCollectionViewCell: UICollectionViewCell {
    var textLabel: UILabel!
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let iconWidth = RD.Size.iconAppSize
        imageView = UIImageView(frame: CGRect(x: (frame.size.width-iconWidth)*0.5, y: 20, width: iconWidth, height: iconWidth))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        contentView.addSubview(imageView)
        
        textLabel = UILabel(frame: CGRect(x: 0, y: frame.size.height * 0.75, width: frame.size.width, height: frame.size.height * 0.25))
        textLabel.font = UIFont.systemFont(ofSize: RD.Size.fontSmall)
        textLabel.textColor = RD.Color.titleBlack
        textLabel.textAlignment = .center
        contentView.addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
