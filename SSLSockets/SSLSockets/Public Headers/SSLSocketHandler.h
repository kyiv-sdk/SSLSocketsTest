//
//  SSLSocketHandler.h
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/15/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "openssl/ssl.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSLSocketHandler : NSObject

/**
    @brief Returns a Boolean value indicating handler status.
    @discussion Value YES returns in case of connection and being ready to send/receive data, value NO returns in case of socket is disconnected and cannot send/receive data. Use 'stopHandling' method to change state.
 */
@property (assign, nonatomic, readonly) BOOL isHandling;

/**
    @brief Socket's SSL-descriptor.
 */
@property (unsafe_unretained, nonatomic, readonly) SSL const *ssl;

/**
    @brief Storage of received data.
 */
@property (strong, nonatomic, readonly) NSArray *receivedInfo;


/**
    @brief Ends handling data received by socket, becomes unready to send data.
 */
- (void)stopHandling;

/**
    @brief Sends data to socket.
    @discussion Function returns YES if data has been successfully sent to socket, or NO in case of handler is not handling (see 'isHandling' property).
    @param data - NSString *representation of data to send in socket.
    @return A boolean value indicates success of sending data in socket.
 
 */
- (BOOL)sendData:(NSString *)data;

@end

NS_ASSUME_NONNULL_END
