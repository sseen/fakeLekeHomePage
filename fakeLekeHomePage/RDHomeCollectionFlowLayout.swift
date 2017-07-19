//
//  RDHomeCollectionFlowLayout.swift
//  fakeLekeHomePage
//
//  Created by sseen on 2017/7/7.
//  Copyright © 2017年 sseen. All rights reserved.
//

import UIKit

class RDHomeCollectionFlowLayout: UICollectionViewFlowLayout {
    
    override var collectionViewContentSize:CGSize {
        
        let contentWidth = self.collectionView?.bounds.size.width
        let contentHeight = RD.CustomCollection.DayHeaderHeight * 2// (HeightPerHour * HoursPerDay)
        let contentSize = CGSize(width: contentWidth!, height: contentHeight)
        
        return contentSize
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Cells
        let attributesArray = super.layoutAttributesForElements(in: rect);
        guard self.collectionView != nil else {return attributesArray;}
        for attributes in attributesArray ?? [] {
            let aIndex = attributes.indexPath
            attributes.frame = CGRect(x: (self.itemWidth() + 1 ) * (CGFloat)(attributes.indexPath.item % 4) ,
                                      y: RD.CustomCollection.HourHeaderWidth * (CGFloat)(1 + aIndex.item / 4) + CGFloat(aIndex.item / 4),
                                      width: self.itemWidth(),
                                      height: RD.CustomCollection.HourHeaderWidth)
            
            layoutAttributes.append(attributes)
        }
        
        // Supplementary views
        let headerIndexPaths = self.indexPathsHeaderViewsInRect(rect)
        for indexPath in headerIndexPaths {
            // let indexPath = IndexPath(item: 0, section: 0)
            if let attributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath) {
                layoutAttributes.append(attributes)
            }
            
        }
        
        return layoutAttributes
    }
    

    
    func indexPathsHeaderViewsInRect(_ rect:CGRect) -> [IndexPath] {
        var indexPaths:[IndexPath] = []
        if rect.minY <= RD.CustomCollection.DayHeaderHeight {
            
            let aIndexPath = IndexPath(item: 0, section: 0)
            indexPaths.append(aIndexPath)
        }
        
        return indexPaths
    }
    
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        // let attributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        
        if elementKind == UICollectionElementKindSectionHeader{
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
