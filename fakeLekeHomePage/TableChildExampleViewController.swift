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
    func scrollDid()
    func scrollEndDecelerating(_ contentOffSet: CGPoint, velocity:Bool)
}

class TableChildExampleViewController: UITableViewController, IndicatorInfoProvider {

    let cellIdentifier = "postCell"
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
        tableView.register(UINib(nibName: "PostCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        if blackTheme {
            tableView.backgroundColor = UIColor(red: 15/255.0, green: 16/255.0, blue: 16/255.0, alpha: 1.0)
        }
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
        return DataProvider.sharedInstance.postsData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PostCell,
            let data = DataProvider.sharedInstance.postsData.object(at: indexPath.row) as? NSDictionary else { return PostCell() }

        cell.configureWithData(data)
        if blackTheme {
            cell.changeStylToBlack()
        }
        return cell
    }
    
    // MARK: - scroll view
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  offset = scrollView.contentOffset.y
        let  velocityY = scrollView.panGestureRecognizer.velocity(in: self.view).y
        // print ("\(offset), \(scrollView.panGestureRecognizer.state),\(velocityY)")
        
        self.velocity = velocityY < 0 ? true : false;
        
        //if ([scrollView isEqual:_mainTable]) {
        
        
        switch (scrollView.panGestureRecognizer.state) {
            
        case .began:
            
            scrollView.delegate?.scrollViewDidEndDecelerating!(scrollView)
            
            // User began dragging
            break
            
        case .changed:
            
            scrollView.delegate?.scrollViewDidEndDecelerating!(scrollView)
            
            // User is currently dragging the scroll view
            break
            
        case .possible:
            
            if (scrollView.contentOffset.y<10) {
                scrollView.delegate?.scrollViewDidEndDecelerating!(scrollView)
            }
            
            // The scroll view scrolling but the user is no longer touching the scrollview (table is decelerating)
            break
            
        case .ended:
            
            break;
            
            
        default:
            
            break;
            
            
        }
        //}

    }
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate.scrollEndDecelerating(scrollView.contentOffset, velocity: self.velocity)
    }

    // MARK: - IndicatorInfoProvider

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}
