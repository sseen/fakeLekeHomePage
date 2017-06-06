//  ButtonBarExampleViewController.swift
//  XLPagerTabStrip ( https://github.com/xmartlabs/XLPagerTabStrip )
//
//  Copyright (c) 2017 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import XLPagerTabStrip

@objc(nextHomeScrollDelegate)
protocol nextHomeScrollDelegate {
    func nextScrollEndDecelerating(_ contentOffset: CGPoint, velocity:Bool)
    func nextScrollEndDeceleratingWithTable(_ contentOffset: CGPoint, velocity:Bool, table:UIView)
}

class ButtonBarExampleViewController: ButtonBarPagerTabStripViewController, homeScrollDelegate {

    var isReload = false
    var nextDelegate: nextHomeScrollDelegate!
    
//    http://blog.scottlogic.com/2014/11/20/swift-initialisation.html
//    折腾这个init 方法也是够了,最后参数 nextDelegate 后面加个 ！ 后解决了
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        // Custom initialization
//    }
    
//    init(_ coder: NSCoder?=nil, nextDelegate : nextHomeScrollDelegate) {
//        self.nextDelegate = nextDelegate
//        
//        super.init(coder: coder!)!
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        buttonBarView.selectedBar.backgroundColor = .orange
        buttonBarView.backgroundColor = UIColor(red: 7/255, green: 185/255, blue: 155/255, alpha: 1)
    }

    // MARK: - PagerTabStripDataSource

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = TableChildExampleViewController(style: .plain, itemInfo: "Table View", delegate: self)
        let child_2 = ChildExampleViewController(itemInfo: "View")
        let child_3 = TableChildExampleViewController(style: .grouped, itemInfo: "Table View 2", delegate: self)
        let child_4 = ChildExampleViewController(itemInfo: "View 2")
        let child_5 = TableChildExampleViewController(style: .plain, itemInfo: "Table View 3", delegate: self)
        let child_6 = ChildExampleViewController(itemInfo: "View 3")
        let child_7 = TableChildExampleViewController(style: .grouped, itemInfo: "Table View 4", delegate: self
        )
        let child_8 = ChildExampleViewController(itemInfo: "View 4")

        guard isReload else {
            return [child_1, child_2, child_3, child_4, child_5, child_6, child_7, child_8]
        }

        var childViewControllers = [child_1, child_2, child_3, child_4, child_6, child_7, child_8]

        for index in childViewControllers.indices {
            let nElements = childViewControllers.count - index
            let n = (Int(arc4random()) % nElements) + index
            if n != index {
                swap(&childViewControllers[index], &childViewControllers[n])
            }
        }
        let nItems = 1 + (arc4random() % 8)
        return Array(childViewControllers.prefix(Int(nItems)))
    }
    
    func scrollEndDecelerating(_ contentOffSet: CGPoint, velocity:Bool) {
         nextDelegate.nextScrollEndDecelerating(contentOffSet, velocity: velocity)
    }
    func scrollEndDeceleratingWithTable(_ contentOffSet: CGPoint, velocity: Bool, table: UIView) {
        nextDelegate.nextScrollEndDeceleratingWithTable(contentOffSet, velocity: velocity, table: self.view)
    }
    
    func scrollDid() {
        
    }

    override func reloadPagerTabStripView() {
        isReload = true
        if arc4random() % 2 == 0 {
            pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
        } else {
            pagerBehaviour = .common(skipIntermediateViewControllers: arc4random() % 2 == 0)
        }
        super.reloadPagerTabStripView()
    }
}
