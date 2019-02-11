//
//  ScreenshotsManager.m
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/11/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "ScreenshotsManager.h"

@interface ScreenshotsManager ()

@property (weak, nonatomic) UIView *view;

@end



@implementation ScreenshotsManager

- (void)startSessionWithWindow {
    [self _startSessionWithBlock:^{
        self.view = [[[UIApplication sharedApplication] delegate] window];
    }];
}

- (void)startSessionWithView:(UIView *)view {
    [self _startSessionWithBlock:^{
        self.view = view;
    }];
}

- (void)_startSessionWithBlock:(void (^)(void))block {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.0);
        dispatch_group_leave(group);
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

- (UIImage *)takeScreenshot {
    __block UIImage *screenshot;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        screenshot = UIGraphicsGetImageFromCurrentImageContext();
        dispatch_group_leave(group);
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    return screenshot;
}

- (void)endSession {
    UIGraphicsEndImageContext();
    self.view = nil;
}

+ (instancetype)sharedInstance {
    static id _sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ScreenshotsManager alloc] init];
    });
    return _sharedInstance;
}

@end
