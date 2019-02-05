//
//  RCSocketSharingHandler.m
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/5/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "RCSocketSharingHandler.h"

@interface RCSocketSharingHandler ()

@property (strong, nonatomic) dispatch_queue_t serialThread;

@end



@implementation RCSocketSharingHandler

- (void)handleJSON:(NSDictionary *)json {
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.serialThread = dispatch_queue_create("com.o9e6y.RCSocketSharingHandler", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

@end
