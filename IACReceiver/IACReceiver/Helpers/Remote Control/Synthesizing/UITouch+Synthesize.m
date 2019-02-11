//
//  UITouch+Synthesize.m
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/7/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "GSEventProxy.h"
#import "UITouch+Synthesize.h"

@implementation UITouch (Synthesize)

- (id)initWithLocation:(nonnull NSValue *)location {
    
    CGPoint _loc = [location CGPointValue];
    UIWindow *_window = [[[UIApplication sharedApplication] delegate] window];
    UIView *_target = [_window hitTest:_loc withEvent:nil];
    GSEventProxy *gsEventProxy = [[GSEventProxy alloc] init];
    gsEventProxy->x1 = _loc.x;
    gsEventProxy->y1 = _loc.y;
    gsEventProxy->x2 = _loc.x;
    gsEventProxy->y2 = _loc.y;
    gsEventProxy->x3 = _loc.x;
    gsEventProxy->y3 = _loc.y;
    gsEventProxy->sizeX = 1.0;
    gsEventProxy->sizeY = 1.0;
    gsEventProxy->flags = 0x3010180;
    gsEventProxy->type = 3001;
    
    UITouch *touch = [[UITouch _createTouchesWithGSEvent:gsEventProxy phase:0 view:_target] anyObject];
    
    NSNumber *_timestamp = [NSNumber numberWithDouble:[[NSProcessInfo processInfo] systemUptime]];
    NSMutableArray *_gestureRecognizers = [[NSMutableArray alloc] initWithArray:[_target gestureRecognizers]];
    [_gestureRecognizers addObjectsFromArray:[_window gestureRecognizers]];
   
    
    [touch setValue:@1 forKey:@"_tapCount"];
    [touch setValue:location forKey:@"_locationInWindow"];
    [touch setValue:location forKey:@"_preciseLocationInWindow"];
    [touch setValue:location forKey:@"_previousLocationInWindow"];
    [touch setValue:location forKey:@"_precisePreviousLocationInWindow"];
    [touch setValue:@1 forKeyPath:@"_touchFlags._firstTouchForView"];
    [touch setValue:@1 forKeyPath:@"_touchFlags._isTap"];
    [touch setValue:_timestamp forKeyPath:@"_timestamp"];
    [touch setValue:_timestamp forKeyPath:@"_initialTouchTimestamp"];
    [touch setValue:_gestureRecognizers forKey:@"_gestureRecognizers"];
    
    return touch;
}

- (void)changeToPhase:(UITouchPhase)phase {
    NSNumber *_phase = [NSNumber numberWithInteger:phase];
    NSNumber *timestamp = [NSNumber numberWithDouble:[[NSProcessInfo processInfo] systemUptime]];
    [self setValue:_phase forKey:@"_phase"];
    [self setValue:timestamp forKeyPath:@"_timestamp"];
}

- (void)changeLocationInWindow:(NSValue *)location {
    NSNumber *_timestamp = [NSNumber numberWithDouble:[[NSProcessInfo processInfo] systemUptime]];
    id previousLocation = [self valueForKey:@"_locationInWindow"];
    [self setValue:previousLocation forKey:@"_previousLocationInWindow"];
    [self setValue:previousLocation forKey:@"_precisePreviousLocationInWindow"];
    [self setValue:location forKey:@"_preciseLocationInWindow"];
    [self setValue:location forKey:@"_locationInWindow"];
    [self setValue:_timestamp forKeyPath:@"_timestamp"];
}

@end

