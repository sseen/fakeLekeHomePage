//
//  BannerCollectionReusableView.m
//  fakeLekeHomePage
//
//  Created by sseen on 2017/5/3.
//  Copyright © 2017年 sseen. All rights reserved.
//

#import "BannerCollectionReusableView.h"

@implementation BannerCollectionReusableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        imgView.image = [UIImage imageNamed:@"banner"];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:imgView];
        imgView.center = self.center;
    }
    
    return self;
}

@end
