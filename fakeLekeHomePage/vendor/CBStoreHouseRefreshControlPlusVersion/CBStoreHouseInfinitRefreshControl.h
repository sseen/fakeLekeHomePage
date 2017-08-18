//
//  CBStoreHouseInfinitRefreshControl.h
//  CBStoreHouseRefreshControl
//
//  Created by sseen on 2017/8/15.
//  Copyright © 2017年 Suyu Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBStoreHouseInfinitRefreshControl : UIView
+ (CBStoreHouseInfinitRefreshControl*)attachToScrollView:(UIScrollView *)scrollView
                                           target:(id)target
                                    refreshAction:(SEL)refreshAction
                                            plist:(NSString *)plist;

+ (CBStoreHouseInfinitRefreshControl*)attachToScrollView:(UIScrollView *)scrollView
                                           target:(id)target
                                    refreshAction:(SEL)refreshAction
                                            plist:(NSString *)plist
                                            color:(UIColor*)color
                                        lineWidth:(CGFloat)lineWidth
                                       dropHeight:(CGFloat)dropHeight
                                            scale:(CGFloat)scale
                             horizontalRandomness:(CGFloat)horizontalRandomness
                          reverseLoadingAnimation:(BOOL)reverseLoadingAnimation
                          internalAnimationFactor:(CGFloat)internalAnimationFactor;

- (void)scrollViewDidScroll;

- (void)scrollViewDidEndDragging;

- (void)finishingLoading;
@end
