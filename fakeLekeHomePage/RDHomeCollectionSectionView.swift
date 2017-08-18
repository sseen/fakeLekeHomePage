//
//  RDHomeCollectionSectionView.swift
//  fakeLekeHomePage
//
//  Created by sseen on 2017/7/4.
//  Copyright © 2017年 sseen. All rights reserved.
//

import UIKit
import FSPagerView
import SDWebImage
import YYCache

class RDHomeCollectionSectionView: UICollectionReusableView,FSPagerViewDataSource,FSPagerViewDelegate {
    var pagerControl: FSPageControl!
    var pagerView: FSPagerView!
    
    private var _imageNames: [String]!
    var imageNames:[String]! {
        get {
            var array:[String] = []
            let object = RD.Cache.scrollImages?.object(forKey: RD.Cache.Key.scrollImages)
            if  nil != object {
                array = object as! [String]
            } else {
                array = ["banner"]
            }
            
            return array
        }
        set {
            _imageNames = newValue
            RD.Cache.scrollImages?.setObject(newValue as NSCoding, forKey: RD.Cache.Key.scrollImages)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pagerView = FSPagerView(frame: CGRect(x: 0, y: 0, width: K.ViewSize.SCREEN_WIDTH, height: 120))
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pagerView.itemSize = .zero
        pagerView.isInfinite = true
        pagerView.automaticSlidingInterval = 3.0
        
        pagerControl = FSPageControl(frame: CGRect(x: 0, y: 0, width: K.ViewSize.SCREEN_WIDTH, height: 20))
        pagerControl.numberOfPages = self.imageNames.count
        pagerControl.contentHorizontalAlignment = .right
        pagerControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        pagerView.dataSource = self
        pagerView.delegate = self
        
        self.addSubview(pagerView)
        
        pagerView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- FSPagerView DataSource
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.imageNames.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.sd_setImage(with: URL(string: self.imageNames[index]), placeholderImage: UIImage(named:"banner"), options: .refreshCached, completed: { (image, error, tyep, url) in
            
        })
        //UIImage(named: self.imageNames[index])
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.text = index.description+index.description
        return cell
    }
    
    // MARK:- FSPagerView Delegate
    
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        self.pagerControl.currentPage = index
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pagerControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.pagerControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }
}
