//
//  ViewController.m
//  fakeLekeHomePage
//
//  Created by sseen on 2017/4/28.
//  Copyright © 2017年 sseen. All rights reserved.
//

#import "ViewController.h"
#import "BannerCollectionReusableView.h"
#import "UINavigationBar+Awesome.h"
#import "ChildViewController.h"

typedef NS_ENUM(NSInteger, HomeHeaderState) {
    HomeHeaderStateHided,
    HomeHeaderStateShowing,
    HomeHeaderStatePartial
};

static const float marginItem = 20;
static const float navPlusStatus = 64;
static const float animationTime = 0.33;
static const float delayTime = 0;
static const float bannerHeight = 150;
#define color  [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1]
#define NAVBAR_CHANGE_POINT 50

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (strong, nonatomic) UIView *headerViewDel;
@property (strong, nonatomic) UICollectionView *mainCollection;

@property (assign, nonatomic) HomeHeaderState isUp; // -1:hide 0:part of show 1:all show
@property (assign, nonatomic) Boolean velocity;

@property (assign, nonatomic) CGFloat screenWidth;
@property (assign, nonatomic) CGFloat screenHeight;
@property (assign, nonatomic) CGFloat upMoveOffset;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    _isUp = 1;
    _upMoveOffset = 0;
    _screenWidth = CGRectGetWidth(self.view.frame);
    _screenHeight = CGRectGetHeight(self.view.frame);

    // table
    [_mainTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell0"];
    _mainTable.decelerationRate = UIScrollViewDecelerationRateFast;
    _mainTable.scrollIndicatorInsets = UIEdgeInsetsMake(40, 0, 0, 0);

    // collection
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.headerReferenceSize = CGSizeMake(_screenWidth, bannerHeight);
    self.mainCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, _screenWidth, bannerHeight * 2 ) collectionViewLayout:layout];
    _mainCollection.backgroundColor = [UIColor whiteColor];
    [_mainCollection setDataSource:self];
    [_mainCollection setDelegate:self];
    [_mainCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_mainCollection registerClass:[BannerCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    [self.view addSubview:_mainCollection];
    
    self.headerViewDel = _mainCollection;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // [self scrollViewDidScroll:_mainTable];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // float headerHeight = CGRectGetHeight(_headerViewDel.frame);
    // _mainTable.frame = CGRectMake(0, headerHeight, _screenWidth, _screenHeight - navPlusStatus);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.navigationController.navigationBar lt_reset];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor darkGrayColor];
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        BannerCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}


#pragma mark - flow

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = [self itemWidth];
    return CGSizeMake(width, width);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return [self itemSpacing];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return [self itemSpacing] / 2;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,20,0,20);  // top, left, bottom, right
    // return UIEdgeInsetsMake(0,8,0,8);
}

- (float)itemSpacing {
    int cellsInLine = 4;
    float width = [self itemWidth];
    // item space
    float spacing = ((CGRectGetWidth(self.view.frame) - cellsInLine * width - marginItem * 2) / (cellsInLine -1));
    
    return spacing;
}

- (float)itemWidth {
    int cellsInLine = 6;
    float width = roundf(( CGRectGetWidth(self.view.frame) - cellsInLine + 1) / cellsInLine);
    return width;
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
    lblName.textColor = [UIColor darkGrayColor];
    lblName.text = @"title";
    [contentView addSubview:lblName];
    
    return contentView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *sboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChildViewController *vc = [sboard instantiateViewControllerWithIdentifier:@"ChildViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offset = scrollView.contentOffset.y ;
    CGFloat velocityY = [scrollView.panGestureRecognizer  velocityInView:self.view].y;
    NSLog(@"%f, %ld, %f", offset, (long)scrollView.panGestureRecognizer.state, velocityY);
    
    self.velocity = velocityY < 0 ? true : false;
    
    if ([scrollView isEqual:_mainTable]) {
        
        switch (scrollView.panGestureRecognizer.state) {
                
            case UIGestureRecognizerStateBegan: {
                
                [[scrollView delegate] scrollViewDidEndDecelerating:scrollView];
                
                // User began dragging
                break;
            }
            case UIGestureRecognizerStateChanged: {
                
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
            
            default: {
                
                break;
            }
                
        }
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // isUp : header show or hide
    // velocity : because 主动调用 scrollViewDidEndDecelerating 后，scrollview 还会在滑动结束后自己调用一次，加上加速度代表是主动调用
    // velocity negative imply up, active down
    NSLog(@"%ld, %d, %f", (long)_isUp, _velocity, scrollView.contentOffset.y);
    
    float yOffset = scrollView.contentOffset.y;
    float headerHeight = CGRectGetHeight(_headerViewDel.frame);
    float tableHeight  = CGRectGetHeight(scrollView.frame);
    
    if (_isUp!=HomeHeaderStateShowing && !_velocity) {// scroll up, header disappear will show
        if ( scrollView.contentOffset.y<10) {
            
            [UIView animateWithDuration:animationTime delay:delayTime options:UIViewAnimationOptionCurveLinear animations:^{
                _headerViewDel.frame = CGRectMake(0, 0, _screenWidth, headerHeight);
                _mainTable.frame = CGRectMake(0, headerHeight, _screenWidth, tableHeight);
            } completion:nil];
            
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
            
            _isUp = HomeHeaderStateShowing;
        }
        else { // partial show
            
            // 向上滚动到一定距离的时候才 animation
            if (_upMoveOffset < yOffset) {
                _upMoveOffset = yOffset;
            }
            
            if (_upMoveOffset - yOffset > 40*1.5) {
                [UIView animateWithDuration:animationTime delay:delayTime options:UIViewAnimationOptionCurveLinear animations:^{
                    _headerViewDel.frame = CGRectMake(0, navPlusStatus - bannerHeight, _screenWidth, headerHeight);
                    _mainTable.frame = CGRectMake(0, navPlusStatus + headerHeight -  bannerHeight, _screenWidth, tableHeight );
                } completion:nil];
                
                _upMoveOffset = yOffset;
                
                _isUp = HomeHeaderStatePartial;
            }
            
        }

    }
    
    if (_velocity && yOffset > 10) {//scroll down, header show will hide
        [UIView animateWithDuration:animationTime delay:delayTime options:UIViewAnimationOptionCurveLinear animations:^{
            _headerViewDel.frame = CGRectMake(0, navPlusStatus - headerHeight , _screenWidth, headerHeight);
            _mainTable.frame = CGRectMake(0, navPlusStatus, _screenWidth, tableHeight);
            
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:1]];
            
        } completion:nil];
        
        if (_isUp==HomeHeaderStateShowing) {
            _isUp = HomeHeaderStateHided;
        }
    }
    
}

@end
