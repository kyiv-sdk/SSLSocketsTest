//
//  ClientApplication+CoreDataClass.m
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/4/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//
//

#import "RCManager.h"
#import "NSDictionary+ProjectAdditions.h"
#import "ClientApplication+CoreDataClass.h"

@implementation ClientApplication

@synthesize ssl = _ssl;

- (void)terminate {
    NSString *action = [[NSDictionary RCTerminationJSON] convertToString];
    [[RCManager sharedInstance] sendAction:action toClient:self.ssl];
}

- (void)wipeStorage {
    NSString *action = [[NSDictionary RCWipingJSON] convertToString];
    [[RCManager sharedInstance] sendAction:action toClient:self.ssl];
}

@end
