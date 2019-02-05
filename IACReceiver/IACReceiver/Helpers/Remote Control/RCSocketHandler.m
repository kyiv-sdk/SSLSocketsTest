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
#import "CoreDataManager+Protected.h"

@implementation RCSocketHandler

#pragma mark - Methods
- (void)handleJSON:(NSDictionary *)json {
    NSString *action = [json objectForKey:kRCActionKey];
    if ([action isEqualToString:kRCTerminateApplication]) {
        [self terminateApplication];
    } else if ([action isEqualToString:kRCWipeApplicationStorage]) {
        [self wipeStorage];
    }
}

- (void)terminateApplication {
    [[RCManager sharedInstance] stopSession];
    exit(RCServerSocketPort);
}

- (void)wipeStorage {
    [[CoreDataManager sharedManager] wipeStorage];
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
