//
//  RemoteServerLogger.m
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/31/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "NetworkManager.h"
#import "RemoteServerLogger.h"

@interface RemoteServerLogger ()

@property (strong, nonatomic) dispatch_queue_t serialThread;
@property (strong, nonatomic) NSURL *remoteServerURL;

@end

@implementation RemoteServerLogger

- (void)logMessage:(NSString *)message withPriority:(SSLLoggingPriority)priority {
    dispatch_async(self.serialThread, ^{
        NSNumber *lpriority = [NSNumber numberWithInt:priority];
        [[NetworkManager sharedManager] sendLogMessage:message withPriority:lpriority toRemoteServerWithURL:self.remoteServerURL];
    });
}

+ (instancetype)sharedInstance {
    static id _sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[RemoteServerLogger alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.minPriority = SSLLoggingPriorityLog;
        self.serialThread = dispatch_queue_create("com.o9e6y.RemoteServerLogger", DISPATCH_QUEUE_SERIAL);
        self.remoteServerURL = [NSURL URLWithString:@"https://demo8568188.mockable.io/log/"];
    }
    return self;
}

@end
