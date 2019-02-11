//
//  RCSocketAcionsHandler.m
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/1/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "CoreDataManager.h"
#import "ProjectConstants.h"
#import "RCApplicationStorage.h"
#import "RCSocketActionsHandler.h"

@implementation RCSocketAcionsHandler

- (void)handleJSON:(NSDictionary *)json fromClient:(nonnull SSL *)client {
    NSString *action = [json valueForKey:kRCActionKey];
    if ([action isEqualToString:kRCActionConnect]) {
        return [self didConnectClient:client withInfo:json];
    }
    else if ([action isEqualToString:kRCActionDisconnect]) {
        return [self didDisconnectClient:client withInfo:json];
    }
    else {
        NSLog(@"RCSocketAcionsHandler received unexpected action = %@", action);
    }
}

- (void)didConnectClient:(SSL *)clientSSL withInfo:(NSDictionary *)info {
    [[CoreDataManager sharedInstance] getApplicationWithInfo:info completion:^(ClientApplication * _Nonnull application) {
        [application setSsl:clientSSL];
        [[RCApplicationStorage sharedInstance] addApplication:application];
    }];
}

- (void)didDisconnectClient:(SSL *)clientSSL withInfo:(NSDictionary *)info {
    [[CoreDataManager sharedInstance] getApplicationWithInfo:info completion:^(ClientApplication * _Nonnull application) {
        [[RCApplicationStorage sharedInstance] removeApplication:application];
    }];
}

@end
