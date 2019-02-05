//
//  RemoteControlController.m
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/5/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "RCSocketDelegate.h"
#import <SSLSockets/SSLSockets.h>
#import "RCSocketSharingHandler.h"
#import "RemoteControlController.h"

@interface RemoteControlController ()

@property (strong, nonatomic) ClientApplication *clientApplication;
@property (strong, nonatomic) SSLServerSocket *screenSharingSocket;

@end



@implementation RemoteControlController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareViewController];
}

- (void)prepareViewController {
    if (self.clientApplication) {
        int port = [self runSharingSocket];
        [self.clientApplication shareScreenToPort:port];
    }
}

- (int)runSharingSocket {
    int port;
    RCSocketSharingHandler *handler = [[RCSocketSharingHandler alloc] initWithPresenter:self];
    RCSocketDelegate *delegate = [[RCSocketDelegate alloc] initWithHandler:handler];
    
    do {
        port = 1+ arc4random_uniform(65534);
        self.screenSharingSocket = [[SSLServerSocket alloc] initWithPort:port andDelegate:delegate];
        [self.screenSharingSocket startSocket];
    } while (![self.screenSharingSocket isRunning]);
    return port;
}

#pragma mark - <RCSharingPresenter>
- (void)updateWithImage:(UIImage *)image {
    [self.remoteDisplay setImage:image];
}

#pragma mark - <RCApplicationPresenter>
- (void)setApplication:(ClientApplication *)application {
    self.clientApplication = application;
}

- (void)dealloc {
    [self.clientApplication stopSharingScreen];
}

@end
