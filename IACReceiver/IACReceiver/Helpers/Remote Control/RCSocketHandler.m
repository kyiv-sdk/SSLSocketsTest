//
//  RCSocketHandler.m
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/4/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "RCManager.h"
#import "RCSocketHandler.h"
#import "ProjectConstants.h"

@implementation RCSocketHandler

#pragma mark - Methods
- (void)handleJSON:(NSDictionary *)json {
    NSString *action = [json objectForKey:kRCActionKey];
    if ([action isEqualToString:kRCTerminateApplication]) {
        [self terminateApplication];
    }
}

- (void)terminateApplication {
    [[RCManager sharedInstance] stopSession];
    exit(RCServerSocketPort);
}

#pragma mark - Singletone
+ (instancetype)sharedInstance {
    static id _sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[RCSocketHandler alloc] init];
    });
    return _sharedInstance;
}

@end
