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
    NSString *identifier = [json valueForKey:kRCIdentifierKey];
    NSString *action = [json valueForKey:kRCActionKey];
    if ([action isEqualToString:kRCActionConnect]) {
        return [self didConnectClient:client withIdentifier:identifier];
    } else if ([action isEqualToString:kRCActionDisconnect]) {
        return [self didDisconnectClient:client withIdentifier:identifier];
    }
}

- (void)didConnectClient:(SSL *)clientSSL withIdentifier:(NSString *)identifier {
    [[CoreDataManager sharedInstance] getApplicationWithIdentifier:identifier completion:^(ClientApplication * _Nonnull application) {
        [[RCApplicationStorage sharedInstance] addClientApplication:application];
    }];
}

- (void)didDisconnectClient:(SSL *)clientSSL withIdentifier:(NSString *)identifier {
    ClientApplication *app = [[RCApplicationStorage sharedInstance] removeApplicationWithIdentifier:identifier];
    if (app) {
        [[CoreDataManager sharedInstance] updateLastConnectionForApplication:app];
    }
}


#pragma mark - Constructor
+ (instancetype)sharedInstance {
    static id _sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.serialThread = dispatch_queue_create("com.o9e6y.RCSocketHandler", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

@end
