//
//  RCSocketHandler.m
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/1/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "RCSocketHandler.h"
#import "CoreDataManager.h"
#import "ProjectConstants.h"
#import "RCApplicationStorage.h"

@interface RCSocketHandler ()

@property (strong, nonatomic) dispatch_queue_t serialThread;

@end



@implementation RCSocketHandler

- (void)handleJSON:(NSDictionary *)json fromClient:(nonnull SSL *)client {
    NSString *action = [json valueForKey:kRCActionKey];
    if ([action isEqualToString:kRCActionConnect]) {
        return [self didConnectClient:client withInfo:json];
    } else if ([action isEqualToString:kRCActionDisconnect]) {
        return [self didDisconnectClient:client withInfo:json];
    } else {
        NSLog(@"UnexpectedKey = %@", action);
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

#pragma mark - Constructor
- (instancetype)init {
    self = [super init];
    if (self) {
        self.serialThread = dispatch_queue_create("com.o9e6y.RCSocketHandler", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

@end
