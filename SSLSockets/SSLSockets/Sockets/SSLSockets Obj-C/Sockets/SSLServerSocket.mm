//
//  SSLServerSocket.m
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/11/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "SSLServerSocket.h"
#import "BSDServerSocket.h"
#import "SSLSocket+Protected.h"
#import "SSLSocketHandler.h"
#import "SSLSocketHandler+Protected.h"
#import <Foundation/Foundation.h>

@implementation SSLServerSocket

#pragma mark - Getters
- (NSArray *)acceptedSockets {
    NSMutableArray *acceptedSockets = [[NSMutableArray alloc] init];
    const std::vector<BSDSocketHandler *> _acceptedSockets = ((BSDServerSocket *)self.socket)->getAcceptedSockets();
    for (BSDSocketHandler *handler : _acceptedSockets) {
        SSLSocketHandler *objcHandler = [[SSLSocketHandler alloc] initWithBSDSocketHandler:handler];
        [acceptedSockets addObject:objcHandler];
    }
    return acceptedSockets;
}

#pragma mark - Methods
- (BOOL)sendData:(NSString *)data toSSL:(SSL const *)ssl {
    const char *dataToSend = [data UTF8String];
    return ((BSDServerSocket *)self.socket)->sendData(dataToSend, ssl);
}

#pragma mark - Constructors
- (instancetype)initWithPort:(int)port {
    return [self initWithPort:port andDelegate:nil];
}

- (instancetype)initWithPort:(int)port andDelegate:(id <SSLSocketDelegate>)delegate {
    self = [super init];
    if (self) {
        BSDSocketDelegate *cDelegate = new BSDSocketDelegate((void *)CFBridgingRetain(delegate));
        self.socket = new BSDServerSocket(port, cDelegate);
    }
    return self;
}

#pragma mark - Destructor
- (void)dealloc {
    delete (BSDServerSocket *)self.socket;
}

@end
