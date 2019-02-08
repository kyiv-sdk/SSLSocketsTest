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
- (id)initInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
