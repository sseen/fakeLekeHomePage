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
import SwiftMessages
import SDWebImage
import PYSearch
import Moya


import ObjectMapper

class RDViewController: UIViewController {
    
    var headerVIewDel:UIView!
    var mainCollection:UICollectionView!
    var isUp = RD.HomeHeaderState.showing
    var velocity = false
    var upMoveOffset:CGFloat = 0
    var vc:ButtonBarExampleViewController!
    var section:RDHomeCollectionSectionView!
    var sections = Variable([AnimatableSectionModel<String, RDEveryoneAppsModel>]())
    // app one line or two lines
    var iconLines:CGFloat = 1
    // view请求到app应用数量以后的table y起点
    
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let searchButton = UIButton(type: .custom)
        searchButton.frame = CGRect(x: 0, y: 0, width: 170, height: 35)
        self.navigationItem.titleView = searchButton
        searchButton.rx.tap
            .subscribe(onNext: { [weak self] in self?.pushSearchView()})
            .disposed(by: K.Rx.disposeBag)
        
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
        vc.view.frame = vc.view.frame.offsetBy(dx: 0, dy: RD.CommonUnit.bannerHeight +  RD.CommonUnit.iconsHeight * iconLines + RD.CommonUnit.navPlusStatus)
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
        
        // 为了实现滑动轮播图也能达到滑动 table 向上收起的效果
        mainCollection.rx.contentOffset
            .observeOn(MainScheduler.asyncInstance)
            .map { $0.y}
            .subscribe{ [weak self] in
                // self?.storeHouseRefreshControl.scrollViewDidScroll()
                
                let table:UIView = (self?.vc.view)!
                // scroll up collectionview
                if self?.isUp == .showing {
                    
                    if $0.element! > CGFloat(0) {
                        UIView.animate(withDuration: RD.CommonUnit.animationTime, delay: RD.CommonUnit.delayTime, options: .curveLinear, animations: {
                            self?.headerVIewDel.frame = CGRect(x: 0, y: -(RD.CommonUnit.bannerHeight +  RD.CommonUnit.iconsHeight * (self?.iconLines)!), width: K.ViewSize.SCREEN_WIDTH, height: K.ViewSize.SCREEN_HEIGHT)
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
                        var frameDown = table.frame
                        self?.navigationController?.navigationBar.alpha = (1 + $0.element!/(44))
                        frameDown.origin.y = RD.CommonUnit.navPlusStatus + RD.CommonUnit.bannerHeight + RD.CommonUnit.iconsHeight * (self?.iconLines)! - $0.element!
                        table.frame = frameDown
                    }
                }
            }.disposed(by: K.Rx.disposeBag)
        
        
        // rx data
        // self.sections.value = initialValue
        let cvReloadDataSource = RxCollectionViewSectionedReloadDataSource<AnimatableSectionModel<String, RDEveryoneAppsModel>>()
        // cell
        cvReloadDataSource.configureCell = { (datasouce, cv, ip, i) in
            print(datasouce.sectionModels)
            
            let data = datasouce.sectionModels[ip.section].items[ip.row]
            let cell = cv.dequeueReusableCell(withReuseIdentifier: RD.CommonUnit.cellReuse, for: ip) as! RDHomeCollectionViewCell
            cell.imageView.sd_setImage(with: URL(string: data.icon!), placeholderImage: UIImage(named:""), options: .refreshCached, completed: { (image, error, type, url) in
                
            })
            cell.textLabel.text = data.name
            
            return cell
        }
        // section
        cvReloadDataSource.supplementaryViewFactory = { (dataSource, cv, kind, ip) in
            
            // var section:UICollectionReusableView!
            
                if kind == UICollectionElementKindSectionHeader {
                    self.section = cv.dequeueReusableSupplementaryView(ofKind: kind , withReuseIdentifier: RD.CommonUnit.headerReuse, for: ip) as! RDHomeCollectionSectionView
                }
                if kind == UICollectionElementKindSectionFooter {
                    self.section = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: ip) as! RDHomeCollectionSectionView
                }
            
            return self.section
         }
        
        self.sections.asObservable()
            .asObservable().observeOn(MainScheduler.instance)
            .bind(to: mainCollection.rx.items(dataSource: cvReloadDataSource))
            .disposed(by: K.Rx.disposeBag)

        let layout = RDHomeCollectionFlowLayout();
        mainCollection.collectionViewLayout = layout
        
        self.requestEveryoneApps()

        

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //vc.view.frame = vc.view.frame.offsetBy(dx: 0, dy: -RD.CommonUnit.bannerHeight*0.5)
        
        
        
    }
}

extension RDViewController {
    func pushSearchView() {
        // 1. Create an Array of popular search
        let hotSeaches = ["Java", "Python", "Objective-C", "Swift", "C", "C++", "PHP", "C#", "Perl", "Go", "JavaScript", "R", "Ruby", "MATLAB"];
        // 2. Create a search view controller
        let searchViewController = PYSearchViewController(hotSearches: hotSeaches, searchBarPlaceholder: "搜索编程语言") { (vc, bar, text) in
            
        }
        searchViewController?.hotSearchStyle = .normalTag
        searchViewController?.searchHistoryStyle = .default
        let nav = UINavigationController(rootViewController: searchViewController!)
        
        self.present(nav, animated: true, completion: nil)

    }
    
    
    func requestScorllImages(){
        
        let endpointClosure = { (target: CommonUnsafe) -> Endpoint<CommonUnsafe> in
            let url2 = url(target)
            return Endpoint(url: url2, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
        }
        let provider = MoyaProvider(endpointClosure: endpointClosure)
        provider.request(.scrollPageViews) { (result) in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let statusCode = moyaResponse.statusCode
            // do something with the response data or statusCode
            case let .failure(error): break
                // this means there was a network failure - either the request
                // wasn't sent (connectivity), or no response was received (server
                // timed out).  If the server responds with a 4xx or 5xx error, that
                // will be sent as a ".success"-ful response.
            }
        }
        
        RDCommonUnsafeProvider.request(.scrollPageViews)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapObject(type: RDModelBase<RDScrollPageViewModel>.self)
            .subscribe { event in
                switch event {
                case let .next(response):
                    var array = [String]()
                    for one:RDScrollPageViewModel in response.data! {
                        guard let str = one.logoPathList else {
                            continue
                        }
                        array.append(str.first!)
                    }
                    self.section.imageNames = array
                    self.section.pagerView.reloadData()
                    
                case let .error(error):
                    RDMessage.showError(content: error.localizedDescription)
                default:
                    break
                }
        }
    }
    
    func requestEveryoneApps(){
        RDCommonUnsafeProvider.request(.everyonesApps)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapObject(type: RDModelBase<RDEveryoneAppsModel>.self)
            .subscribe { event in
                switch event {
                case let .next(response):
                    if  (response.data?.count)! <= 0 {
                        self.iconLines = 0
                        self.vc.view.frame = CGRect(origin: CGPoint(x:0, y:RD.CommonUnit.bannerHeight + RD.CommonUnit.navPlusStatus), size: self.vc.view.frame.size)
                    }
                    self.sections.value = [AnimatableSectionModel<String, RDEveryoneAppsModel>(model: "section 1", items: response.data!)]
                    self.requestScorllImages()
                case let .error(error):
                    RDMessage.showError(content: error.localizedDescription)
                default:
                    break
                }
        }
    }
    
    func requestMyApps() {
        
    }
}


// MARK: - next delegate
extension RDViewController:nextHomeScrollDelegate {
    func nextScrollEndDeceleratingWithTable(_ contentOffset: CGPoint, velocity: Bool, table: UIView) {
        let yOffset = contentOffset.y
        let headerHeight = RD.CommonUnit.bannerHeight +  RD.CommonUnit.iconsHeight * iconLines
        let tableHeight = self.view.frame.height
        
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
