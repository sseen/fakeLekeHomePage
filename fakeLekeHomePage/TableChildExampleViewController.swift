//  TableChildExampleViewController.swift
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

protocol homeScrollDelegate {
    func scrollEndDeceleratingWithTable(_ contentOffSet: CGPoint, velocity:Bool, table:UIView)
}

class TableChildExampleViewController: UITableViewController, IndicatorInfoProvider {

    let cellIdentifier = "RDHomeDayThingsTableViewCell"
    var blackTheme = false
    var itemInfo = IndicatorInfo(title: "View")
    var velocity = false
    var delegate : homeScrollDelegate

    init(style: UITableViewStyle, itemInfo: IndicatorInfo, delegate:homeScrollDelegate) {
        self.itemInfo = itemInfo
        self.delegate = delegate
        super.init(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: cellIdentifier, bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = 117
        tableView.separatorStyle = .none
        if blackTheme {
            tableView.backgroundColor = UIColor(red: 15/255.0, green: 16/255.0, blue: 16/255.0, alpha: 1.0)
        }
        
        tableView.rx.contentOffset.map {$0.y}.subscribe{ [weak self] in
            self?.title = "\($0)"
            }.disposed(by: K.Rx.disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RDHomeDayThingsTableViewCell,
            let _ = DataProvider.sharedInstance.postsData.object(at: indexPath.row) as? NSDictionary else { return RDHomeDayThingsTableViewCell() }

        cell.lblTitle.text = "我的日程"
        cell.lblSubTitle.text = "安全教育研讨会"
        cell.lblTime.text = "08:00"
        cell.lblSubTime.text = "14:30-16:30"
        cell.lblSubAddress.text = "行政楼"
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello world")
        self.navigationController?.pushViewController(ChildExampleViewController(itemInfo: " ssn "), animated: true)
    }
    
    // MARK: - scroll view
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // let  offset = scrollView.contentOffset.y
        let  velocityY = scrollView.panGestureRecognizer.velocity(in: self.view).y
        // print ("\(offset), \(scrollView.panGestureRecognizer.state),\(velocityY)")
        
        self.velocity = velocityY < 0 ? true : false;
        
        switch (scrollView.panGestureRecognizer.state) {
            
        case .began:
            
            delegate.scrollEndDeceleratingWithTable(scrollView.contentOffset, velocity: self.velocity, table: self.view)
            // User began dragging
            break
            
        case .changed:
            
            delegate.scrollEndDeceleratingWithTable(scrollView.contentOffset, velocity: self.velocity, table: self.view)
            // User is currently dragging the scroll view
            break
            
        case .possible:
            
            if (scrollView.contentOffset.y<10) {
                delegate.scrollEndDeceleratingWithTable(scrollView.contentOffset, velocity: self.velocity, table: self.view)
            }
            // The scroll view scrolling but the user is no longer touching the scrollview (table is decelerating)
            break
            
        case .ended:
            
            break;
            
        default:
            break;
        }
    }

    // MARK: - IndicatorInfoProvider

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}
