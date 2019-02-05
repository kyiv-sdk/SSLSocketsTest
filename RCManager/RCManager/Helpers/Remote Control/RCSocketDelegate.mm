//
//  RCSocketDelegate.m
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/1/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "RCSocketHandler.h"
#import "RCSocketDelegate.h"

@interface RCSocketDelegate ()

@property (strong, nonatomic) RCSocketHandler *handler;

@end



@implementation RCSocketDelegate

- (void)didReceiveMessage:(NSString *)message fromSSL:(SSL *)ssl {
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    [self.handler handleJSON:json fromClient:ssl];
}

#pragma mark - Constructor
- (instancetype)init {
    self = [super init];
    if (self) {
        self.handler = [[RCSocketHandler alloc] init];
    }
    return self;
}

@end
