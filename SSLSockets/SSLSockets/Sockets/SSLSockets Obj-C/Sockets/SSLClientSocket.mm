//
//  SSLClientSocket.m
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/11/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "SSLClientSocket.h"
#import "BSDClientSocket.h"
#import "SSLSocket+Protected.h"
#import "SSLSocketDelegate+Protected.h"

@implementation SSLClientSocket

#pragma mark - Mathods
- (BOOL)sendData:(NSString *)data {
    const char *dataToSend = [data UTF8String];
    return ((BSDClientSocket *)self.socket)->sendData(dataToSend);
}


#pragma mark - Constructors
- (instancetype)initWithPort:(int)port {
    return [self initWithAddress:@"127.0.0.1" port:port andDelegate:nil];
}

- (instancetype)initWithPort:(int)port andDelegate:(SSLSocketDelegate *)delegate {
    return [self initWithAddress:@"127.0.0.1" port:port andDelegate:delegate];
}

- (instancetype)initWithAddress:(NSString *)address port:(int)port andDelegate:(SSLSocketDelegate *)delegate {
    self = [super init];
    if (self) {
        std::string addr = std::string([address UTF8String]);
        self.socket = new BSDClientSocket(addr, port, delegate.cDelegate);
    }
    return self;
}

#pragma mark - Destructor
- (void)dealloc {
    delete (BSDClientSocket *)self.socket;
}

@end
