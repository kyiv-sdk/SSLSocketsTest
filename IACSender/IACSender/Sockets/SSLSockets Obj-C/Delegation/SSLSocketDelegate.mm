//
//  SSLSocketDelegate.m
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/18/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "SSLSocketDelegate+Protected.h"

@implementation SSLSocketDelegate

- (void)didReceiveMessage:(NSString *)message fromSSL:(SSL *)ssl {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cDelegate = new BSDSocketDelegate((__bridge void *)self);
    }
    return self;
}


- (void)dealloc {
    free(self.cDelegate);
}

@end
