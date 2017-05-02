//
//  ViewController.m
//  fakeLekeHomePage
//
//  Created by sseen on 2017/4/28.
//  Copyright © 2017年 sseen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource,  UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (strong, nonatomic) UIView *headerView;

@property (assign, nonatomic) Boolean isUp;
@property (assign, nonatomic) Boolean velocity;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 100)];
    _headerView.backgroundColor = [UIColor lightGrayColor];
    
    [_mainTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell0"];
    _mainTable.decelerationRate = UIScrollViewDecelerationRateFast;
    [self.view addSubview: _headerView];
    
    _mainTable.scrollIndicatorInsets = UIEdgeInsetsMake(40, 0, 0, 0);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
    cell.textLabel.text = [ NSString stringWithFormat:@"item %ld",(long)indexPath.row ];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    lblName.textColor = [UIColor purpleColor];
    lblName.text = @"title";
    contentView.backgroundColor = [UIColor cyanColor];
    [contentView addSubview:lblName];
    
    return contentView;
}

#pragma mark - scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offset = scrollView.contentOffset.y ;
    NSLog(@"%f, %ld", offset, (long)scrollView.panGestureRecognizer.state);
    
    if ([scrollView isEqual:_mainTable]) {
        
        switch (scrollView.panGestureRecognizer.state) {
                
            case UIGestureRecognizerStateBegan: {
                CGFloat velocityY = [scrollView.panGestureRecognizer  velocityInView:self.view].y;
                NSLog(@"ss %f",velocityY);
                self.velocity = velocityY < 0 ? true : false;
                [[scrollView delegate] scrollViewDidEndDecelerating:scrollView];
                
                // User began dragging
                break;
            }
            case UIGestureRecognizerStateChanged: {
                CGFloat velocityY = [scrollView.panGestureRecognizer  velocityInView:self.view].y;
                NSLog(@"ss %f",velocityY);
                self.velocity = velocityY < 0 ? true : false;
                [[scrollView delegate] scrollViewDidEndDecelerating:scrollView];
                
                // User is currently dragging the scroll view
                break;
            }
            case UIGestureRecognizerStatePossible: {
                
                if (scrollView.contentOffset.y<10) {
                    [[scrollView delegate] scrollViewDidEndDecelerating:scrollView];
                }
                
                // The scroll view scrolling but the user is no longer touching the scrollview (table is decelerating)
                break;
            }
            case UIGestureRecognizerStateEnded: {
                
                
                
                break;
            }
            
            default:
                break;
        }
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // isUp : header show or hide
    // velocity : because 主动调用 scrollViewDidEndDecelerating 后，scrollview 还会在滑动结束后自己调用一次，加上加速度代表是主动调用
    NSLog(@"%d, %d, %f", _isUp, _velocity, scrollView.contentOffset.y);
    if (_isUp && !_velocity && scrollView.contentOffset.y<10) {// header disappear will show
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            _headerView.frame = CGRectMake(0, 64, CGRectGetWidth(_headerView.frame), CGRectGetHeight(_headerView.frame));
            _mainTable.frame = CGRectMake(0, 164, CGRectGetWidth(scrollView.frame), CGRectGetHeight(scrollView.frame));
        } completion:nil];
        
        _isUp = !_isUp;

    }
    if (!_isUp && _velocity) {// header show will hide
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            _headerView.frame = CGRectMake(0, -36, CGRectGetWidth(_headerView.frame), CGRectGetHeight(_headerView.frame));
            _mainTable.frame = CGRectMake(0, 64, CGRectGetWidth(scrollView.frame), CGRectGetHeight(scrollView.frame));
        } completion:nil];
        
         _isUp = !_isUp;
    }
    
}


@end
