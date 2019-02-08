//
//  UITouch+Synthesize.m
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/7/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "UITouch+Synthesize.h"

@implementation UITouch (Synthesize)

- (id)initWithLocation:(nonnull NSValue *)location {
    self = [super init];
    if (self != nil) {
        UIWindow *_window = [[[UIApplication sharedApplication] delegate] window];
        NSNumber *_timestamp = [NSNumber numberWithDouble:[[NSProcessInfo processInfo] systemUptime]];
        UIView *_target = [_window hitTest:[location CGPointValue] withEvent:nil];
        
        NSMutableArray *_gestureRecognizers = [[NSMutableArray alloc] initWithArray:[_window gestureRecognizers]];
        [_gestureRecognizers addObjectsFromArray:[_target gestureRecognizers]];
        
        
        [self setValue:@1 forKey:@"_tapCount"];
        [self setValue:location forKey:@"_locationInWindow"];
        [self setValue:[self valueForKey:@"_locationInWindow"] forKey:@"_previousLocationInWindow"];
        [self setValue:_target forKey:@"_view"];
        [self setValue:_window forKey:@"_window"];
        [self setValue:_window forKey:@"__windowServerHitTestWindow"];
        [self setValue:@0 forKey:@"_phase"];
        [self setValue:@1 forKeyPath:@"_touchFlags._firstTouchForView"];
        [self setValue:@1 forKeyPath:@"_touchFlags._isTap"];
        [self setValue:_timestamp forKeyPath:@"_timestamp"];
        [self setValue:_timestamp forKeyPath:@"_initialTouchTimestamp"];
        [self setValue:@400 forKey:@"_maximumPossiblePressure"];
        
        //[self setValue:_gestureRecognizers forKey:@"_gestureRecognizers"];
    }
    return self;
}

- (void)changeToPhase:(UITouchPhase)phase {
    NSNumber *_phase = [NSNumber numberWithInteger:phase];
    NSNumber *timestamp = [NSNumber numberWithDouble:[[NSProcessInfo processInfo] systemUptime]];
    [self setValue:_phase forKey:@"_phase"];
    [self setValue:timestamp forKeyPath:@"_timestamp"];
}

- (void)changeLocationInWindow:(NSValue *)location {
     NSNumber *_timestamp = [NSNumber numberWithDouble:[[NSProcessInfo processInfo] systemUptime]];
    [self setValue:[self valueForKey:@"_locationInWindow"] forKey:@"_previousLocationInWindow"];
    [self setValue:location forKey:@"_locationInWindow"];
    [self setValue:_timestamp forKeyPath:@"_timestamp"];
}

@end

