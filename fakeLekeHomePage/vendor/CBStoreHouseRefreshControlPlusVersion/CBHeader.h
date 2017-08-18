//
//  CBHeader.h
//  CBStoreHouseRefreshControl
//
//  Created by sseen on 2017/8/15.
//  Copyright © 2017年 Suyu Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    CBStoreHouseRefreshControlStateIdle = 0,
    CBStoreHouseRefreshControlStateRefreshing = 1,
    CBStoreHouseRefreshControlStateDisappearing = 2
} CBStoreHouseRefreshControlState;


extern NSString *const startPointKey ;
extern NSString *const endPointKey   ;
extern NSString *const xKey          ;
extern NSString *const yKey          ;

extern  const CGFloat kloadingIndividualAnimationTiming;
extern  const CGFloat kbarDarkAlpha                    ;
extern  const CGFloat kloadingTimingOffset             ;
extern  const CGFloat kdisappearDuration               ;
extern  const CGFloat krelativeHeightFactor            ;


#define LogSSS      @"HH:mm:ss.SSS"

#ifdef __OBJC__
#define LOGDEBUG 0
#ifdef LOGDEBUG
#define NSLog(format, ...) do {                                             \
fprintf(stderr, "[%s line.%d\t]%s] ",     \
[[CBHeader dateToStringUseFormatter:[NSDate date] formatter:LogSSS] UTF8String], \
__LINE__, [[[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] componentsSeparatedByString:@" "][0] UTF8String]);                        \
printf("%s\n", [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);           \
} while (0)
#else
#define NSLog(format, ...) nil
#endif
#endif

@interface CBHeader : NSObject

+ (NSString *)dateToStringUseFormatter:(NSDate *)date formatter:(NSString *)formatter ;


@end
