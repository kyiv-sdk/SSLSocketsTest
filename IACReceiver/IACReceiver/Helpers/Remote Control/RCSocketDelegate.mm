//
//  RCSocketDelegate.m
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/4/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "RCSocketHandler.h"
#import "RCSocketDelegate.h"

@interface RCSocketDelegate ()

@property (strong, nonatomic) id<RCSocketHandler> handler;

@end



@implementation RCSocketDelegate

#pragma mark - Methods
- (void)didReceiveMessage:(NSString *)message fromSSL:(SSL *)ssl {
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    [self.handler handleJSON:json];
}

#pragma mark - Constructior
- (instancetype)initWithHandler:(id<RCSocketHandler>)handler {
    self = [super init];
    if (self) {
        self.handler = handler;
    }
    return self;
}

@end
