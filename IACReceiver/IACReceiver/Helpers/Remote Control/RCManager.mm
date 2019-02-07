//
//  RCManager.m
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/4/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCManager.h"
#import "ProjectConstants.h"
#import "RCSocketDelegate.h"
#import "RCSocketActionsHandler.h"
#import "RCSocketSharingHandler.h"
#import "NSDictionary+ProjectAdditions.h"

@interface RCManager ()

@property (strong, nonatomic) SSLClientSocket *RCSocket;
@property (strong, nonatomic) SSLClientSocket *screenSharingSocket;

@end



@implementation RCManager

#pragma mark - Methods
- (void)startSession {
    [self.RCSocket startSocket];
    NSString *message = [[NSDictionary RCConnectionJSON] convertedToString];
    [self.RCSocket sendData:message];
}

- (void)stopSession {
    NSString *message = [[NSDictionary RCDisconnectionJSON] convertedToString];
    [self.RCSocket sendData:message];
}

#pragma mark - ScreenSharing
- (void)shareScreenToPort:(int)port {
    RCSocketSharingHandler *handler = [[RCSocketSharingHandler alloc] init];
    RCSocketDelegate *delegate = [[RCSocketDelegate alloc] initWithHandler:handler];
    self.screenSharingSocket = [[SSLClientSocket alloc] initWithAddress:RCServerSocketAddress port:port andDelegate:delegate];
    [self startSharingScreen];
}

- (void)startSharingScreen {
    [self.screenSharingSocket startSocket];
    __block RCManager *weakSelf = self;
    __block UIWindow *weakWindow = [self startCapturing];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while ([weakSelf.screenSharingSocket isRunning]) {
            @autoreleasepool {
                UIImage *screenshot = [self takeScreenShotOfView:weakWindow];
                NSString *action = [[NSDictionary RCSharingJSONWithScreenshot:screenshot] convertedToString];
                [weakSelf.screenSharingSocket sendData:action];
            }
            usleep(kRCScreenSharingDelay);
        }
        [self stopCapturing];
    });
}

- (UIWindow *)startCapturing {
    __block UIWindow *weakWindow;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_main_queue(), ^{
        weakWindow = [[[UIApplication sharedApplication] delegate] window];
        UIGraphicsBeginImageContextWithOptions(weakWindow.frame.size, NO, 0.0);
        dispatch_group_leave(group);
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    return weakWindow;
}

- (UIImage *)takeScreenShotOfView:(UIView *)view {
    __block UIImage *screenshot;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_main_queue(), ^{
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        screenshot = UIGraphicsGetImageFromCurrentImageContext();
        dispatch_group_leave(group);
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    return screenshot;
}

- (void)stopCapturing {
    UIGraphicsEndImageContext();
}


- (void)stopSharingScreen {
    [self.screenSharingSocket stopSocket];
}

#pragma mark - Singletone
+ (instancetype)sharedInstance {
    static id _sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[RCManager alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        RCSocketActionsHandler *handler = [[RCSocketActionsHandler alloc] init];
        RCSocketDelegate *delegate = [[RCSocketDelegate alloc] initWithHandler:handler];
        self.RCSocket = [[SSLClientSocket alloc] initWithAddress:RCServerSocketAddress port:RCServerSocketPort andDelegate: delegate];
    }
    return self;
}

@end
