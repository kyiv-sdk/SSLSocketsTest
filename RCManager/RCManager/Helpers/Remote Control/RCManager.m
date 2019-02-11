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
#import "RCSocketSharingHandler.h"
#import "RCSocketActionsHandler.h"

@interface RCManager ()

@property (strong, nonatomic) SSLServerSocket *RCSocket;
@property (strong, nonatomic) SSLServerSocket *RCSharingSocket;

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

- (int)openSharingSocketWithPresented:(id <RCApplicationPresenter>)presenter {
    int port;
    RCSocketSharingHandler *handler = [[RCSocketSharingHandler alloc] initWithPresenter:presenter];
    RCSocketDelegate *delegate = [[RCSocketDelegate alloc] initWithHandler:handler];
    
    do {
        port = 1+ arc4random_uniform(65534);
        self.RCSharingSocket = [[SSLServerSocket alloc] initWithPort:port andDelegate:delegate];
        [self.RCSharingSocket startSocket];
    } while (![self.RCSharingSocket isRunning]);
    
    return port;
}

- (void)sendGesture:(NSString *)gesture {
    SSLSocketHandler *client = [[self.RCSharingSocket acceptedSockets] firstObject];
    [self.RCSharingSocket sendData:gesture toSSL:client.ssl];
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
        RCSocketAcionsHandler *handler = [[RCSocketAcionsHandler alloc] init];
        RCSocketDelegate *delegate = [[RCSocketDelegate alloc] initWithHandler:handler];
        self.RCSocket = [[SSLServerSocket alloc] initWithPort:RCServerSocketPort andDelegate:delegate];
    }
    return self;
}

@end
