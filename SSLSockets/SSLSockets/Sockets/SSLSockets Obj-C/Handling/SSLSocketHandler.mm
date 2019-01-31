//
//  SSLSocketHandler.m
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/15/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "BSDSocketHandler.h"
#import "SSLSocketHandler.h"
#import "SSLSocketHandler+Protected.h"

@implementation SSLSocketHandler

#pragma mark - Getters
- (const SSL *)ssl {
    return self.handler->getSSL();
}

#pragma mark - Methods
- (void)stopHandling {
    self.handler->stopHandling();
}

- (BOOL)sendData:(NSString *)data {
    const char *dataToSend = [data UTF8String];
    return self.handler->send(dataToSend);
}

#pragma mark - Constructor
- (instancetype)initWithBSDSocketHandler:(BSDSocketHandler *)handler {
    self = [super init];
    if (self) {
        self.handler = handler;
    }
    return self;
}

@end
