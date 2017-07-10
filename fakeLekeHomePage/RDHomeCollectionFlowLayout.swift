//
//  RDHomeCollectionFlowLayout.swift
//  fakeLekeHomePage
//
//  Created by sseen on 2017/7/7.
//  Copyright © 2017年 sseen. All rights reserved.
//

import UIKit

class RDHomeCollectionFlowLayout: UICollectionViewFlowLayout {
    
    var datas:[NumberSection] = [NumberSection]()
    
    override var collectionViewContentSize:CGSize {
        
        let contentWidth = self.collectionView?.bounds.size.width
        let contentHeight = RD.CustomCollection.DayHeaderHeight * 2// (HeightPerHour * HoursPerDay)
        let contentSize = CGSize(width: contentWidth!, height: contentHeight)
        
        return contentSize
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Cells
        let visiableIndexPaths = self.indexPathsOfItemsInRect(rect)
        for indexPath:IndexPath in visiableIndexPaths {
            let attributes = self.layoutAttributesForItem(at: indexPath)
            layoutAttributes.append(attributes!)
        }
        
        // Supplementary views
        let headerIndexPaths = self.indexPathsHeaderViewsInRect(rect)
        for indexPath in headerIndexPaths {
            let attributes = self.layoutAttributesForSupplementaryView(ofKind: RD.CommonUnit.headerReuse, at: indexPath)
            layoutAttributes.append(attributes!)
        }
        
        return layoutAttributes
    }
    
    func indexPathsOfItemsInRect(_ rect:CGRect) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        if datas.count > 0 {
            for index in datas[0].items {
                let a_index = IndexPath(item: index, section: 0)
                indexPaths.append(a_index)
            }
        }
        
        return indexPaths
    }
    
    func indexPathsHeaderViewsInRect(_ rect:CGRect) -> [IndexPath] {
        var indexPaths:[IndexPath] = []
        if rect.minY <= RD.CustomCollection.DayHeaderHeight {
            
            let aIndexPath = IndexPath(item: 0, section: 0)
            indexPaths.append(aIndexPath)
        }
        
        return indexPaths
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = CGRect(x: (self.itemWidth() + 1 ) * (CGFloat)(indexPath.item) ,
                                  y: RD.CustomCollection.HourHeaderWidth * (CGFloat)(indexPath.item % 4),
                                  width: self.itemWidth(),
                                  height: RD.CustomCollection.HourHeaderWidth)
        
        return attributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("oo")
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        
        if elementKind == RD.CommonUnit.headerReuse {
            attributes.frame = CGRect(x: 0, y: 0, width: K.ViewSize.SCREEN_WIDTH, height: RD.CommonUnit.bannerHeight)
        } else {
            attributes.frame = CGRect(x: 0, y: 0, width: K.ViewSize.SCREEN_WIDTH, height: 0)
        }
        
        return attributes
    }
    
    func itemWidth() -> CGFloat {
        let items:CGFloat = 4
        let width = ( K.ViewSize.SCREEN_WIDTH - (items - 1) ) / items
        return width
    }
}
