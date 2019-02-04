//
//  RCManager.m
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/4/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "RCManager.h"
#import "ProjectConstants.h"
#import "RCSocketDelegate.h"
#import "NSString+ProjectAdditions.h"

@interface RCManager ()

@property (strong, nonatomic) SSLClientSocket *RCSocket;

@end



@implementation RCManager

#pragma mark - Methods
- (void)startSession {
    [self.RCSocket startSocket];
    [self.RCSocket sendData:[NSString RCConnectionMesage]];
}

- (void)stopSession {
    [self.RCSocket sendData:[NSString RCDisconnectionMessage]];
    [self.RCSocket stopSocket];
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
        self.RCSocket = [[SSLClientSocket alloc] initWithAddress:RCServerSocketAddress port:RCServerSocketPort andDelegate:[RCSocketDelegate sharedInstance]];
    }
    return self;
}

@end
