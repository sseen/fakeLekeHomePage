//
//  RDViewController.swift
//  fakeLekeHomePage
//
//  Created by sseen on 2017/6/14.
//  Copyright © 2017年 sseen. All rights reserved.
//

import UIKit

enum HomeHeaderState{
    case hided
    case showing
    case partial
}

struct CommonUnit {
    let marginItem = 20
    let navPlusStatus:CGFloat = 64
    let animationTime:TimeInterval = 0.33
    let delayTime:TimeInterval = 0
    let bannerHeight:CGFloat = 150
    let navbar_change_point = 50
    let cellReuse = "cell0"
    let headerReuse = "headerView"
    
    let color = UIColor(colorLiteralRed: 0/255.0, green: 175/255.0, blue: 240/255.0, alpha: 1)
}

class RDViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var headerVIewDel:UIView!
    var mainCollection:UICollectionView!
    var isUp = HomeHeaderState.hided
    var velocity = false
    var screenWidth:CGFloat!
    var screenHeight:CGFloat!
    var upMoveOffset:CGFloat = 0
    let commonUse = CommonUnit()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barStyle = .black
        
        screenWidth = self.view.frame.width
        screenHeight = self.view.frame.height
        
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: screenWidth, height:commonUse.bannerHeight)
        mainCollection = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: commonUse.bannerHeight * 2), collectionViewLayout: layout)
        mainCollection.backgroundColor = UIColor.white
        mainCollection.dataSource = self
        mainCollection.delegate = self
        mainCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: commonUse.cellReuse)
        mainCollection.register(BannerCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: commonUse.headerReuse)
        
        self.view.addSubview(mainCollection)
        self.headerVIewDel = mainCollection;
        
        let vc = ButtonBarExampleViewController(delegate: self)
        vc.view.frame = vc.view.frame.offsetBy(dx: 0, dy: mainCollection.frame.height)
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.clear)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // self.navigationController?.navigationBar.lt_reset()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // self.navigationController?.navigationBar.lt_reset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commonUse.cellReuse, for: indexPath)
        cell.backgroundColor = UIColor.darkGray
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView:UICollectionReusableView! = nil
        
        if kind == UICollectionElementKindSectionHeader {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: commonUse.headerReuse, for: indexPath)
        }
        if kind == UICollectionElementKindSectionFooter {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "FooterView", for: indexPath)
        }
        
        return reusableView
    }

    // MARK: - flow
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.itemWidth()
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.itemSpacing() / 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.itemSpacing()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func itemSpacing() -> CGFloat {
        let cellsInLine:CGFloat = 4
        let width = self.itemWidth()
        // item space
        let spacing = ( self.view.frame.width - cellsInLine * width - CGFloat(commonUse.marginItem * 2 ) ) / (cellsInLine - 1)
        
        return spacing
    }
    
    func itemWidth() -> CGFloat {
        let cellsInLine:CGFloat = 6
        let width = roundf(Float((self.view.frame.width - cellsInLine + 1.0) / cellsInLine))
        return CGFloat(width)
    }
}

// MARK: - next delegate
extension RDViewController:nextHomeScrollDelegate {
    func nextScrollEndDeceleratingWithTable(_ contentOffset: CGPoint, velocity: Bool, table: UIView) {
        let yOffset = contentOffset.y
        let headerHeight = headerVIewDel.frame.height
        let tableHeight = self.view.frame.height - 44 - 20
        
        if isUp != .showing && !velocity {
            if contentOffset.y < 10 {
                UIView.animate(withDuration: commonUse.animationTime, delay: commonUse.delayTime, options: .curveLinear, animations: {
                    self.headerVIewDel.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: headerHeight)
                    table.frame = CGRect(x:0, y:headerHeight, width:self.screenWidth, height:tableHeight)
                }, completion: nil)
                
                self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.clear)
                isUp = .showing
            } else {
                // partial show
                // 向上滚动一定距离才 animation
                if upMoveOffset < yOffset {
                    upMoveOffset = yOffset
                }
                
                if upMoveOffset - yOffset > 40 * 1.5 {
                    UIView.animate(withDuration: commonUse.animationTime, delay: commonUse.delayTime, options: .curveLinear, animations: {
                        self.headerVIewDel.frame = CGRect(x: 0, y: self.commonUse.navPlusStatus - self.commonUse.bannerHeight, width: self.screenWidth, height: headerHeight)
                        table.frame = CGRect(x: 0, y: self.commonUse.navPlusStatus + headerHeight - self.commonUse.bannerHeight, width: self.screenWidth, height: tableHeight)
                    }, completion: nil)
                    
                    upMoveOffset = yOffset
                    isUp = .partial
                }
            }
        }
        
        if velocity && yOffset > 10 {
            //scroll down, header show will hide
            UIView.animate(withDuration: commonUse.animationTime, delay: commonUse.delayTime, options: .curveLinear, animations: {
                self.headerVIewDel.frame = CGRect(x: 0, y: self.commonUse.navPlusStatus - headerHeight, width: self.screenWidth, height: headerHeight)
                table.frame = CGRect(x: 0, y: self.commonUse.navPlusStatus, width: self.screenWidth, height: tableHeight)
                self.navigationController?.navigationBar.lt_setBackgroundColor(self.commonUse.color)
            }, completion: nil)
            
            if isUp == .showing {
                isUp = .hided
            }
        }
    }

}
