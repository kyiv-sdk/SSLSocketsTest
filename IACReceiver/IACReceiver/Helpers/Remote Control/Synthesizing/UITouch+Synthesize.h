//
//  UITouch+Synthesize.h
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/7/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITouch (Synthesize)

- (void)changeToPhase:(UITouchPhase)phase;
- (void)changeLocationInWindow:(NSValue *)location;
- (id)initWithLocation:(NSValue *)location;

@end

NS_ASSUME_NONNULL_END
