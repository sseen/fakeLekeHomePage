//
//  RDViewController.swift
//  fakeLekeHomePage
//
//  Created by sseen on 2017/6/14.
//  Copyright © 2017年 sseen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


typealias NumberSection = AnimatableSectionModel<String, Int>

class RDViewController: UIViewController {
    
    var headerVIewDel:UIView!
    var mainCollection:UICollectionView!
    var isUp = RD.HomeHeaderState.showing
    var velocity = false
    var upMoveOffset:CGFloat = 0
    var vc:ButtonBarExampleViewController!
    
    var sections = Variable([NumberSection]())
    static let initialValue: [AnimatableSectionModel<String, Int>] = [
        NumberSection(model: "section 1", items: [1, 2, 3, 4, 5])
    ]
    
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.isTranslucent = true
        
        mainCollection = UICollectionView(frame: CGRect(x: 0, y: RD.CommonUnit.navPlusStatus, width: K.ViewSize.SCREEN_WIDTH, height: K.ViewSize.SCREEN_HEIGHT), collectionViewLayout: UICollectionViewFlowLayout())
        mainCollection.bounces = true
        mainCollection.alwaysBounceVertical = true
        mainCollection.backgroundColor = UIColor.white
        mainCollection.register(RDHomeCollectionViewCell.self, forCellWithReuseIdentifier: RD.CommonUnit.cellReuse)
        mainCollection.register(RDHomeCollectionSectionView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: RD.CommonUnit.headerReuse)

        self.view.addSubview(mainCollection)
        self.headerVIewDel = mainCollection;
        
        vc = ButtonBarExampleViewController(delegate: self)
        vc.view.frame = vc.view.frame.offsetBy(dx: 0, dy: RD.CommonUnit.bannerPlusIconsHeight + RD.CommonUnit.navPlusStatus)
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
        
        let frameHeight = self.vc.view.frame.origin.y
        mainCollection.rx.contentOffset
            .observeOn(MainScheduler.asyncInstance)
            .map { $0.y}
            .subscribe{ [weak self] in
                
                let table:UIView = (self?.vc.view)!
                // scroll up collectionview
                if self?.isUp == .showing {
                    
                    if $0.element! > CGFloat(0) {
                        UIView.animate(withDuration: RD.CommonUnit.animationTime, delay: RD.CommonUnit.delayTime, options: .curveLinear, animations: {
                            self?.headerVIewDel.frame = CGRect(x: 0, y: -RD.CommonUnit.bannerPlusIconsHeight, width: K.ViewSize.SCREEN_WIDTH, height: K.ViewSize.SCREEN_HEIGHT)
                            table.frame = CGRect(x: 0, y: 64, width: K.ViewSize.SCREEN_WIDTH, height: table.frame.size.height)
                            self?.changeTabStripView(show: true)
                        }, completion: {finished in
                            if self?.isUp == .showing {
                                self?.isUp = .hided
                            }
                        })
                    }
                    // table down
                    if $0.element! < CGFloat(0)  {
                        var frameDown = self?.vc.view.frame
                        self?.navigationController?.navigationBar.alpha = (1 + $0.element!/(44))
                        frameDown?.origin.y = frameHeight - $0.element!
                        self?.vc.view.frame = frameDown!
                    }
                }
            }.disposed(by: K.Rx.disposeBag)
        
        // rx data
        self.sections.value = RDViewController.initialValue
        let cvReloadDataSource = RxCollectionViewSectionedReloadDataSource<NumberSection>()
        // cell
        cvReloadDataSource.configureCell = { (datasouce, cv, ip, i) in
            print(datasouce.sectionModels)
            
            let cell = cv.dequeueReusableCell(withReuseIdentifier: RD.CommonUnit.cellReuse, for: ip) as! RDHomeCollectionViewCell
            cell.textLabel.text = "\(i)"
            cell.backgroundColor = UIColor.darkGray
            
            return cell
        }
        // section
        cvReloadDataSource.supplementaryViewFactory = { (dataSource, cv, kind, ip) in
            
            var section:UICollectionReusableView!
            
                if kind == UICollectionElementKindSectionHeader {
                    section = cv.dequeueReusableSupplementaryView(ofKind: kind , withReuseIdentifier: RD.CommonUnit.headerReuse, for: ip) as! RDHomeCollectionSectionView
                }
                if kind == UICollectionElementKindSectionFooter {
                    section = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: ip) as! RDHomeCollectionSectionView
                }
            
            return section
         }
        
        self.sections.asObservable()
            .asObservable().observeOn(MainScheduler.instance)
            .bind(to: mainCollection.rx.items(dataSource: cvReloadDataSource))
            .disposed(by: K.Rx.disposeBag)
        
        
        if let _ = mainCollection.collectionViewLayout as? UICollectionViewFlowLayout{
            
            let layout = RDHomeCollectionFlowLayout();
            mainCollection.collectionViewLayout = layout
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

// MARK: - next delegate
extension RDViewController:nextHomeScrollDelegate {
    func nextScrollEndDeceleratingWithTable(_ contentOffset: CGPoint, velocity: Bool, table: UIView) {
        let yOffset = contentOffset.y
        let headerHeight = RD.CommonUnit.bannerPlusIconsHeight
        let tableHeight = self.view.frame.height
        
        print(table.frame)
        
        if isUp != .showing && !velocity {
            if contentOffset.y < 10 {
                UIView.animate(withDuration: RD.CommonUnit.animationTime, delay: RD.CommonUnit.delayTime, options: .curveLinear, animations: {
                    self.headerVIewDel.frame = CGRect(x: 0, y: RD.CommonUnit.navPlusStatus, width: K.ViewSize.SCREEN_WIDTH, height: K.ViewSize.SCREEN_HEIGHT)
                    table.frame = CGRect(x:0, y:headerHeight + RD.CommonUnit.navPlusStatus, width:K.ViewSize.SCREEN_WIDTH, height:tableHeight)
                    
                    self.changeTabStripView(show: false)
                }, completion: nil)
                
                isUp = .showing
            } else {
                // partial show
                // 向上滚动一定距离才 animation
                if upMoveOffset < yOffset {
                    upMoveOffset = yOffset
                }
                
                if upMoveOffset - yOffset > 40 * 1.5 {
                    UIView.animate(withDuration: RD.CommonUnit.animationTime, delay: RD.CommonUnit.delayTime, options: .curveLinear, animations: {
                        self.headerVIewDel.frame = CGRect(x: 0, y: -RD.CommonUnit.bannerHeight + RD.CommonUnit.navPlusStatus, width: K.ViewSize.SCREEN_WIDTH, height: K.ViewSize.SCREEN_HEIGHT)
                        table.frame = CGRect(x: 0, y: headerHeight - RD.CommonUnit.bannerHeight + RD.CommonUnit.navPlusStatus, width: K.ViewSize.SCREEN_WIDTH, height: tableHeight)
                        
                        self.changeTabStripView(show: false)
                    }, completion: nil)
                    
                    upMoveOffset = yOffset
                    isUp = .partial
                }
            }
        }
        
        if velocity && yOffset > 10 {
            //scroll down, header show will hide
            UIView.animate(withDuration: RD.CommonUnit.animationTime, delay: RD.CommonUnit.delayTime, options: .curveLinear, animations: {
                self.headerVIewDel.frame = CGRect(x: 0, y: -headerHeight, width: K.ViewSize.SCREEN_WIDTH, height: K.ViewSize.SCREEN_HEIGHT)
                table.frame = CGRect(x: 0, y: RD.CommonUnit.navPlusStatus, width: K.ViewSize.SCREEN_WIDTH, height: tableHeight)
                
                self.changeTabStripView(show: true)
                
            }, completion: nil)
            
            if isUp == .showing {
                isUp = .hided
            }
        }
    }
    
    func changeTabStripView(show isShow:Bool) {
        // first load need set like this also
        var frame = self.vc.buttonBarView.frame
        frame.size.height = isShow ? 44.0 : 0.0
        self.vc.buttonBarView.frame = frame
        
        self.vc.buttonBarView.alpha = isShow ? 1.0 : 0.0
        self.vc.containerView.isScrollEnabled = isShow ? true : false
    }

}
