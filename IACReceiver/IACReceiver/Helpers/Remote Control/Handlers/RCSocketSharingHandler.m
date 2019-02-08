//
//  RCSocketSharingHandler.m
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/5/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "RCManager.h"
#import "ProjectConstants.h"
#import "RCSocketSharingHandler.h"
#import "UITouch+Synthesize.h"
#import "UIEvent+Synthesize.h"

@interface RCSocketSharingHandler ()

@property (strong, nonatomic) dispatch_queue_t serialThread;

@end



@implementation RCSocketSharingHandler

- (void)handleJSON:(NSDictionary *)json {
    NSString *action = [json objectForKey:kRCActionKey];
    
    if ([action isEqualToString:kRCActionScreenSharing]) {
        NSArray *gesture = [json objectForKey:kRCGestureKey];
        [self handleGesture:gesture];
    }
    
    else {
        NSLog(@"RCSocketSharingHandler received unexpected action = %@", action);
    }
}

- (void)handleGesture:(NSArray *)gesture {
    NSMutableArray *touches = [[NSMutableArray alloc] init];
    for (NSDictionary *point in gesture) {
        CGFloat x = [[point objectForKey:@"x"] floatValue];
        CGFloat y = [[point objectForKey:@"y"] floatValue];
        CGPoint _point = CGPointMake(x, y);
        [touches addObject:[NSValue valueWithCGPoint:_point]];
    }
    [self executeGesture:touches];
}

- (void)executeGesture:(NSArray *)touches {
    __block UITouch *touch;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        touch = [[UITouch alloc] initWithLocation:[touches firstObject]];
        UIEvent *touchesBeganEvent = [[UIEvent alloc] initWithTouch:touch];
        [[UIApplication sharedApplication] sendEvent:touchesBeganEvent];
        NSLog(@"Began");
    });
    usleep(100000);
    NSUInteger touchesCount = [touches count];
    [touch changeToPhase:UITouchPhaseMoved];
    for (NSUInteger idx = 1; idx < touchesCount; idx++) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [touch changeLocationInWindow:[touches objectAtIndex:idx]];
            UIEvent *touchesMovedEvent = [[UIEvent alloc] initWithTouch:touch];
            [[UIApplication sharedApplication] sendEvent:touchesMovedEvent];
            NSLog(@"Moved");
        });
    }
    usleep(100000);
    dispatch_async(dispatch_get_main_queue(), ^{
        [touch changeToPhase:UITouchPhaseEnded];
        UIEvent *touchesEndedEvent = [[UIEvent alloc] initWithTouch:touch];
        [[UIApplication sharedApplication] sendEvent:touchesEndedEvent];
        NSLog(@"Ended");
    });
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.serialThread = dispatch_queue_create("com.o9e6y.RCSocketSharingHandler", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

@end
