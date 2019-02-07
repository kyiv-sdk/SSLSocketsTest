//
//  RCSocketActionsHandler.m
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/4/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "RCManager.h"
#import "ProjectConstants.h"
#import "RCSocketActionsHandler.h"
#import "CoreDataManager+Protected.h"

@implementation RCSocketActionsHandler

#pragma mark - Methods
- (void)handleJSON:(NSDictionary *)json {
    NSString *action = [json objectForKey:kRCActionKey];
    if ([action isEqualToString:kRCTerminateApplication]) {
        [self terminateApplication];
    }
    
    else if ([action isEqualToString:kRCWipeApplicationStorage]) {
        [self wipeStorage];
    }
    
    else if ([action isEqualToString:kRCActionStartScreenSharing]) {
        NSNumber *portNumber = [json objectForKey:kRCSharingPortKey];
        if (portNumber) [self shareScreenToPort:[portNumber intValue]];
    }
    
    else if ([action isEqualToString:kRCActionScreenSharing]) {
        NSArray *gesture = [json objectForKey:kRCGestureKey];
        [self executeGesture:gesture];
    }
    
    else if ([action isEqualToString:kRCActionStopScreenSharing]) {
        [self stopSharingScreen];
    }
    
    else {
        NSLog(@"RCSocketActionsHandler reived unexpected action = %@", action);
    }
}

- (void)terminateApplication {
    [[RCManager sharedInstance] stopSession];
    exit(RCServerSocketPort);
}

- (void)wipeStorage {
    [[CoreDataManager sharedManager] wipeStorage];
}

- (void)shareScreenToPort:(int)port {
    [[RCManager sharedInstance] shareScreenToPort:port];
}

- (void)stopSharingScreen {
    [[RCManager sharedInstance] stopSharingScreen];
}

- (void)executeGesture:(NSArray *)gesture {
    NSLog(@"GESTURE:");
    NSMutableArray *touches = [[NSMutableArray alloc] init];
    for (NSDictionary *point in gesture) {
        CGFloat x = [[point objectForKey:@"x"] floatValue];
        CGFloat y = [[point objectForKey:@"y"] floatValue];
        CGPoint _point = CGPointMake(x, y);
        [touches addObject:[NSValue valueWithCGPoint:_point]];
        NSLog(@"%f, %f", x, y);
    }
    NSLog(@"");
}

@end
