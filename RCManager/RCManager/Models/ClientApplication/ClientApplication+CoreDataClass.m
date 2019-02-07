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
@synthesize screenSize = _screenSize;

- (CGFloat)screenAspectRatio {
    return self.screenSize.width/self.screenSize.height;
}

- (void)terminate {
    NSString *action = [[NSDictionary RCTerminationJSON] convertedToString];
    [[RCManager sharedInstance] sendAction:action toClient:self.ssl];
}

- (void)wipeStorage {
    NSString *action = [[NSDictionary RCWipingJSON] convertedToString];
    [[RCManager sharedInstance] sendAction:action toClient:self.ssl];
}

- (void)shareScreenToPort:(int)port {
    NSString *action = [[NSDictionary RCSharingJSONWithPort:port] convertedToString];
    [[RCManager sharedInstance] sendAction:action toClient:self.ssl];
}

- (void)stopSharingScreen {
    NSString *action = [[NSDictionary RCStopSharingJSONWithPort] convertedToString];
    [[RCManager sharedInstance] sendAction:action toClient:self.ssl];
}

- (void)executeGesture:(NSArray *)gesture {
    NSString *action = [[NSDictionary RCGesturingJSONWithGesture:gesture] convertedToString];
    [[RCManager sharedInstance] sendAction:action toClient:self.ssl];
}

@end
