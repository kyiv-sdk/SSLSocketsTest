//
//  RCSocketHandler.m
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/4/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "RCSocketHandler.h"

@implementation RCSocketHandler

#pragma mark - Methods
- (void)handleJSON:(NSDictionary *)json {
    
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
