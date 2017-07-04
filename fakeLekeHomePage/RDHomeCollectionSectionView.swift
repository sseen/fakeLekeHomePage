//
//  RDHomeCollectionSectionView.swift
//  fakeLekeHomePage
//
//  Created by sseen on 2017/7/4.
//  Copyright © 2017年 sseen. All rights reserved.
//

import UIKit

class RDHomeCollectionSectionView: UICollectionReusableView {
    var textLabel: UILabel!
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: K.ViewSize.SCREEN_WIDTH, height: 120))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.image = UIImage(named: "banner")
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
