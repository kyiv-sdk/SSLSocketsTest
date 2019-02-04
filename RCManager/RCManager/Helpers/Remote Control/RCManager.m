//
//  RCManager.m
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/4/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "RCManager.h"
#import "RCSocketDelegate.h"
#import "ProjectConstants.h"

@interface RCManager ()

@property (strong, nonatomic) SSLServerSocket *RCSocket;

@end



@implementation RCManager

- (void)startSession {
    [self.RCSocket startSocket];
}

- (void)stopSession {
    [self.RCSocket stopSocket];
}

- (void)sendAction:(NSString *)action toClient:(SSL *)ssl {
    [self.RCSocket sendData:action toSSL:ssl];
}

#pragma mark - Singletone
+ (instancetype)sharedInstance {
    static id _sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SSLSocketsManager configureCertificatesWithCountry:@"UA"
                                                      state:@"Kyiv"
                                                   location:@"Kyiv"
                                               organization:@"SoftServe"
                                           organizationUnit:@"RemoteControl"
                                                 commonName:@"com.softserve.remotecontrol"
                                               emailAddress:@"ohord2@softserveinc.com"];
        _sharedInstance = [[RCManager alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.RCSocket = [[SSLServerSocket alloc] initWithPort:RCServerSocketPort andDelegate:[RCSocketDelegate sharedInstance]];
    }
    return self;
}

@end
