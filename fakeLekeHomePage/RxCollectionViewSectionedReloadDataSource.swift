//
//  RxCollectionViewSectionedReloadDataSource.swift
//  fakeLekeHomePage
//
//  Created by sseen on 2017/7/4.
//  Copyright © 2017年 sseen. All rights reserved.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa
import RxDataSources


open class RxCollectionViewSectionedReloadDataSource<S: SectionModelType>
    : CollectionViewSectionedDataSource<S>
, RxCollectionViewDataSourceType {
    
    public typealias Element = [S]
    
    public override init() {
        super.init()
    }
    
    open func collectionView(_ collectionView: UICollectionView, observedEvent: Event<Element>) {
        UIBindingObserver(UIElement: self) { dataSource, element in
            #if DEBUG
                self._dataSourceBound = true
            #endif
            dataSource.setSections(element)
            collectionView.reloadData()
            }.on(observedEvent)
    }
}
