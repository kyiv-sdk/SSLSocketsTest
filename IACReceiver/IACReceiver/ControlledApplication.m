//
//  ControlledApplication.m
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/6/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "ControlledApplication.h"

@implementation ControlledApplication

- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
}

- (BOOL)sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event {
    return [super sendAction:action to:target from:sender forEvent:event];
}

+ (UIApplication *)sharedApplication {
    static id _sharedApplication;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedApplication = [[ControlledApplication alloc] init];
    });
    return _sharedApplication;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

@end
