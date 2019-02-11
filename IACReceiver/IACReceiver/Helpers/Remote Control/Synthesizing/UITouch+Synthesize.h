//
//  UITouch+Synthesize.h
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/7/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GSEventProxy;

NS_ASSUME_NONNULL_BEGIN

@interface UITouch (Synthesize)

- (void)changeToPhase:(UITouchPhase)phase;
- (void)changeLocationInWindow:(NSValue *)location;
- (id)initWithLocation:(NSValue *)location;
+ (id)_createTouchesWithGSEvent:(GSEventProxy *)arg1 phase:(long long)arg2 view:(id)arg3;

@end

NS_ASSUME_NONNULL_END
