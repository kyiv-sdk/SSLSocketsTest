//
//  SSLSocket.m
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/11/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "SSLSocket.h"
#import "BSDSocket.h"
#import "SSLSocket+Protected.h"

@implementation SSLSocket

#pragma mark - Getters
- (BOOL)isReady {
    return self.socket->isReady();
}

- (BOOL)isRunning {
    return self.socket->isRunning();
}

- (int)port {
    return self.socket->port;
}

- (NSString *)address {
    const char* address = self.socket->address.c_str();
    NSStringEncoding encoding = [NSString defaultCStringEncoding];
    return [NSString stringWithCString:address encoding:encoding];
}

#pragma mark - Methods
- (BOOL)startSocket {
    return self.socket->startSocket();
}

- (void)stopSocket {
    self.socket->stopSocket();
}

@end
