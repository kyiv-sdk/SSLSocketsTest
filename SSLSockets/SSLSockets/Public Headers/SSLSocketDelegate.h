//
//  SSLSocketDelegate.h
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/18/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "openssl/ssl.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SSLSocketDelegate

/**
    @brief Method that will be called each time Socket will receive message.
    @discussion Dispite NSString *type of parameter Socket may receive any convertable to NSString *type, you should remember it. You may also use some metadata to define type of exchanged messages.
    @param message - NSString *representation of info, received by Socket.
 */
- (void)didReceiveMessage:(NSString *)message fromSSL:(SSL *)ssl;

@end

NS_ASSUME_NONNULL_END
