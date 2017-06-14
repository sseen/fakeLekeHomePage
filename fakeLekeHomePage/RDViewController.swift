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
    let navPlusStatus = 64
    let animationTime = 0.33
    let delayTime = 0
    let bannerHeight = 150
    let navbar_change_point = 50
    
    let color = UIColor(colorLiteralRed: 0/255.0, green: 175/255.0, blue: 240/255.0, alpha: 1)
}

class RDViewController: UIViewController,UICollectionViewFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, nextHomeScrollDelegate {
    
    var headerVIewDel:UIView!
    var mainCollection:UICollectionView!
    var isUp = HomeHeaderState.hided
    var velocity = false
    var screenWidth:Int!
    var screenHeight:Int!
    var upMoveOffset = 0
    let commonUse = CommonUnit()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.clear)
        self.navigationController?.navigationBar.barStyle = .black
        
        screenWidth = Int(self.view.frame.width)
        screenHeight = Int(self.view.frame.height)
        
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: screenWidth, height:commonUse.bannerHeight)
        mainCollection = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: commonUse.bannerHeight * 2), collectionViewLayout: layout)
        mainCollection.backgroundColor = UIColor.white
        mainCollection.dataSource = self
        mainCollection.delegate = self
        mainCollection.register(UICollectionViewCell, forCellWithReuseIdentifier: <#T##String#>)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
