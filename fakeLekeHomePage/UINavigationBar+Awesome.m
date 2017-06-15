//
//  UINavigationBar+Awesome.m
//  LTNavigationBar
//
//  Created by ltebean on 15-2-15.
//  Copyright (c) 2015 ltebean. All rights reserved.
//

#import "UINavigationBar+Awesome.h"
#import <objc/runtime.h>

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

@implementation UINavigationBar (Awesome)
static char overlayKey;
static char gradientLayKey;

- (CAGradientLayer *)gradientLay{
    return objc_getAssociatedObject(self, &gradientLayKey);
}

- (void)setGradientLay:(CAGradientLayer *)gradientLay {
    objc_setAssociatedObject(self, &gradientLayKey, gradientLay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lt_setBackgroundColor:(UIColor *)backgroundColor
{

    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;    // Should not set `UIViewAutoresizingFlexibleHeight`
        
        self.gradientLay = [CAGradientLayer layer];
        self.gradientLay.frame = CGRectMake(0, 0, [UIApplication sharedApplication].statusBarFrame.size.width, CGRectGetHeight(self.bounds) );
        // 直接渐变到相同的颜色，最底部会出现一条隐约的白线分割
        // 直接渐变到背景色一样，会让图片遮住的部分也染上背景色，比如这里图片是灰色，背景是白色，上部分灰色有点变白的感觉
        // 三种颜色，中间的颜色位于前后两色之间，作为过渡，白色部分距离短影响小
        self.gradientLay.colors = [NSArray arrayWithObjects:
                                (id)UIColorFromRGBWithAlpha(0x5e5e5e,1).CGColor,
                                (id)UIColorFromRGBWithAlpha(0xb5b5b5,0).CGColor, nil];
        self.gradientLay.locations = @[@0,@1];
        self.gradientLay.startPoint = CGPointMake(0, 0);
        self.gradientLay.endPoint = CGPointMake(0, 1);
        
        [self.overlay.layer addSublayer:self.gradientLay];
        
        [[self.subviews firstObject] insertSubview:self.overlay atIndex:0];
    }
    
    if (![backgroundColor isEqual:[UIColor clearColor]]) {
        self.gradientLay.hidden = true;
    }else {
        self.gradientLay.hidden = false;
    }
    
    self.overlay.backgroundColor = backgroundColor;
    
}

- (void)lt_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)lt_setElementsAlpha:(CGFloat)alpha
{
    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = alpha;
//    when viewController first load, the titleView maybe nil
    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
            obj.alpha = alpha;
        }
        if ([obj isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")]) {
            obj.alpha = alpha;
        }
    }];
}

- (void)lt_reset
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}
@end
