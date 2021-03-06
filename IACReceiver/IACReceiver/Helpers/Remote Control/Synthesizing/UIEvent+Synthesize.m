//
//  UIEvent+Synthesize.m
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/7/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <objc/runtime.h>
#import "GSEventProxy.h"
#import "UIEvent+Synthesize.h"

@implementation UIEvent (Synthesize)

- (id)initWithTouch:(UITouch *)touch {
    CGPoint location = [touch locationInView:touch.window];
    GSEventProxy *gsEventProxy = [[GSEventProxy alloc] init];
    gsEventProxy->x1 = location.x;
    gsEventProxy->y1 = location.y;
    gsEventProxy->x2 = location.x;
    gsEventProxy->y2 = location.y;
    gsEventProxy->x3 = location.x;
    gsEventProxy->y3 = location.y;
    gsEventProxy->sizeX = 1.0;
    gsEventProxy->sizeY = 1.0;
    gsEventProxy->flags = ([touch phase] == UITouchPhaseEnded) ? 0x1010180 : 0x3010180;
    gsEventProxy->type = 3001;
    
    //
    // On SDK versions 3.0 and greater, we need to reallocate as a
    // UITouchesEvent.
    //
    Class touchesEventClass = objc_getClass("UITouchesEvent");
    if (touchesEventClass && ![[self class] isEqual:touchesEventClass])
    {
        self = [touchesEventClass alloc];
    }
    NSMutableSet *touches = [NSMutableSet setWithObjects:touch, nil];
    NSSet *immutableTouches = [NSSet setWithObject:touch];
    self = [self _initWithEvent:gsEventProxy touches:touches];
    if (self) {
        [self setValue:immutableTouches forKey:@"_allTouchesImmutableCached"];
        [self setValue:[touch valueForKey:@"_timestamp"] forKey:@"_timestamp"];
    }
    return self;
}

@end
