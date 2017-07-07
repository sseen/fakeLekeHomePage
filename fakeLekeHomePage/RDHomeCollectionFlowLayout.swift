//
//  RDHomeCollectionFlowLayout.swift
//  fakeLekeHomePage
//
//  Created by sseen on 2017/7/7.
//  Copyright © 2017年 sseen. All rights reserved.
//

import UIKit

class RDHomeCollectionFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Cells
        let visiableIndexPaths = self.indexPathsOfItemsInRect(rect)
        for indexPath:IndexPath in visiableIndexPaths {
            let attributes = self.layoutAttributesForItem(at: indexPath)
            layoutAttributes.append(attributes!)
        }
        
        // Supplementary views
        let headerIndexPaths =
        
        return layoutAttributes
    }
    
    func indexPathsOfItemsInRect(_ rect:CGRect) -> [IndexPath] {
        let dataSource = self.collectionView?.dataSource as! RxCollectionViewSectionedReloadDataSource<NumberSection>
        var indexPaths = [IndexPath]()
        if dataSource._rx_numberOfSections(in: self.collectionView!) > 0 {
            for index in dataSource[0].items {
                let a_index = IndexPath(item: index, section: 0)
                indexPaths.append(a_index)
            }
        }
        
        return indexPaths
    }
    
    func indexPathsHeaderViewsInRect(_ rect:CGRect) -> [IndexPath] {
        
    }

}
