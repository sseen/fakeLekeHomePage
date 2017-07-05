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
    let bannerHeight:CGFloat = 120
    let navbar_change_point = 50
    let cellReuse = "cell0"
    let headerReuse = "headerView"
    
    let color = UIColor(colorLiteralRed: 0/255.0, green: 175/255.0, blue: 240/255.0, alpha: 1)
}

typealias NumberSection = AnimatableSectionModel<String, Int>

class RDViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    var headerVIewDel:UIView!
    var mainCollection:UICollectionView!
    var isUp = HomeHeaderState.hided
    var velocity = false
    var upMoveOffset:CGFloat = 0
    let commonUse = CommonUnit()
    
    var sections = Variable([NumberSection]())
    static let initialValue: [AnimatableSectionModel<String, Int>] = [
        NumberSection(model: "section 1", items: [1, 2, 3, 4, 5, 6])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barStyle = .black
        
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: K.ViewSize.SCREEN_WIDTH, height:commonUse.bannerHeight)
        mainCollection = UICollectionView(frame: CGRect(x: 0, y: 0, width: K.ViewSize.SCREEN_WIDTH, height: commonUse.bannerHeight * 2), collectionViewLayout: layout)
        mainCollection.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        mainCollection.backgroundColor = UIColor.white
        mainCollection.delegate = self
        mainCollection.register(RDHomeCollectionViewCell.self, forCellWithReuseIdentifier: commonUse.cellReuse)
        mainCollection.register(RDHomeCollectionSectionView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: commonUse.headerReuse)

        self.view.addSubview(mainCollection)
        self.headerVIewDel = mainCollection;
        
        let vc = ButtonBarExampleViewController(delegate: self)
        vc.view.frame = vc.view.frame.offsetBy(dx: 0, dy: mainCollection.frame.height)
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
        
        // rx data
        self.sections.value = RDViewController.initialValue
        let cvReloadDataSource = RxCollectionViewSectionedReloadDataSource<NumberSection>()
        // cell
        cvReloadDataSource.configureCell = { (_, cv, ip, i) in
            let cell = cv.dequeueReusableCell(withReuseIdentifier: self.commonUse.cellReuse, for: ip) as! RDHomeCollectionViewCell
            cell.textLabel.text = "\(i)"
            cell.backgroundColor = UIColor.darkGray
            
            return cell
        }
        // section
        cvReloadDataSource.supplementaryViewFactory = { (dataSource, cv, kind, ip) in
            
            var section:UICollectionReusableView! = nil
            
            if kind == UICollectionElementKindSectionHeader {
                section = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.commonUse.headerReuse, for: ip) as! RDHomeCollectionSectionView
            }
            if kind == UICollectionElementKindSectionFooter {
                section = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: ip) as! RDHomeCollectionSectionView
            }
            
            return section
        }
        self.sections.asObservable()
            .bind(to: mainCollection.rx.items(dataSource: cvReloadDataSource))
            .disposed(by: K.Rx.disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // self.navigationController?.navigationBar.lt_reset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - flow
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: K.ViewSize.SCREEN_WIDTH, height: commonUse.bannerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.itemWidth()
        return CGSize(width: width, height: commonUse.bannerHeight/2) // two lines两排
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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
        let tableHeight = self.view.frame.height
        
        if isUp != .showing && !velocity {
            if contentOffset.y < 10 {
                UIView.animate(withDuration: commonUse.animationTime, delay: commonUse.delayTime, options: .curveLinear, animations: {
                    self.headerVIewDel.frame = CGRect(x: 0, y: 0, width: K.ViewSize.SCREEN_WIDTH, height: headerHeight)
                    table.frame = CGRect(x:0, y:headerHeight, width:K.ViewSize.SCREEN_WIDTH, height:tableHeight)
                }, completion: nil)
                
                isUp = .showing
            } else {
                // partial show
                // 向上滚动一定距离才 animation
                if upMoveOffset < yOffset {
                    upMoveOffset = yOffset
                }
                
                if upMoveOffset - yOffset > 40 * 1.5 {
                    UIView.animate(withDuration: commonUse.animationTime, delay: commonUse.delayTime, options: .curveLinear, animations: {
                        self.headerVIewDel.frame = CGRect(x: 0, y: -self.commonUse.bannerHeight, width: K.ViewSize.SCREEN_WIDTH, height: headerHeight)
                        table.frame = CGRect(x: 0, y: headerHeight - self.commonUse.bannerHeight, width: K.ViewSize.SCREEN_WIDTH, height: tableHeight)
                    }, completion: nil)
                    
                    upMoveOffset = yOffset
                    isUp = .partial
                }
            }
        }
        
        if velocity && yOffset > 10 {
            //scroll down, header show will hide
            UIView.animate(withDuration: commonUse.animationTime, delay: commonUse.delayTime, options: .curveLinear, animations: {
                self.headerVIewDel.frame = CGRect(x: 0, y: -self.commonUse.navPlusStatus - headerHeight, width: K.ViewSize.SCREEN_WIDTH, height: headerHeight)
                table.frame = CGRect(x: 0, y: 0, width: K.ViewSize.SCREEN_WIDTH, height: tableHeight)
            }, completion: nil)
            
            if isUp == .showing {
                isUp = .hided
            }
        }
    }

}
