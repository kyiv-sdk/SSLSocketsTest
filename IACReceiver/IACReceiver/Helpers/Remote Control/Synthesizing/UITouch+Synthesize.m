//
//  UITouch+Synthesize.m
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/7/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "UITouch+Synthesize.h"

@implementation UITouch (Synthesize)

- (id)initInView:(UIView *)view {
    self = [super init];
    if (self != nil)
    {
        CGRect frameInWindow;
        if ([view isKindOfClass:[UIWindow class]]) {
            frameInWindow = view.frame;
        }
        else {
            frameInWindow = [view.window convertRect:view.frame fromView:view.superview];
        }
    
        NSNumber *_timestamp = [NSNumber numberWithDouble:[NSDate timeIntervalSinceReferenceDate]];
        CGPoint point = CGPointMake(frameInWindow.origin.x + 0.5 * frameInWindow.size.width, frameInWindow.origin.y + 0.5 * frameInWindow.size.height);
        UIView *_target = [view.window hitTest:point withEvent:nil];
        
        [self setValue:@1 forKey:@"_tapCount"];
        [self setValue:[NSValue valueWithCGPoint:point] forKey:@"_locationInWindow"];
        [self setValue:[self valueForKey:@"_locationInWindow"] forKey:@"_previousLocationInWindow"];
        [self setValue:_target forKey:@"_view"];
        [self setValue:view.window forKey:@"_window"];
        [self setValue:@0 forKey:@"_phase"]; // UITouchPhaseBegan
        [self setValue:@1 forKeyPath:@"_touchFlags._firstTouchForView"];
        [self setValue:@1 forKeyPath:@"_touchFlags._isTap"];
        [self setValue:_timestamp forKeyPath:@"_timestamp"];
    }
    return self;
}

- (void)changeToPhase:(UITouchPhase)phase {
    NSNumber *_phase = [NSNumber numberWithInteger:phase];
    NSNumber *timestamp = [NSNumber numberWithDouble:[NSDate timeIntervalSinceReferenceDate]];
    [self setValue:_phase forKey:@"_phase"];
    [self setValue:timestamp forKeyPath:@"_timestamp"];
}

@end

