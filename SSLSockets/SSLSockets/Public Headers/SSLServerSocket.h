//
//  SSLServerSocket.h
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/11/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "SSLSocket.h"
#import "openssl/ssl.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSLServerSocket : SSLSocket

/**
    @brief Sorage that contains accepted sockets in SSLSocketHandler *representation.
 */
@property (strong, nonatomic, readonly) NSArray *acceptedSockets;

/**
    @brief Sends given message to known accepted Sockets SSL.
    @param data - any information, converted to NSString *, that will be sent to SSLServerSocket.
    @param ssl - descriptor of accepted SSLServerSocket that will receive given data.
    @return YES if message was successfully send or NO if Socket is not configured/not running (check isReady and isRunning properties).
 */
- (BOOL)sendData:(NSString *)data toSSL:(SSL const *)ssl;

/**
    @brief Convenience initializer, creates and configures SSLServerSocket.
    @discussion Calls designated initializer, creates and configures SSL Server Socket with given port, will not have delegate (received messages will be ignored).
    @param port - number between 1 and 65535 which will be retained as Socket port.
    @return SSLServerSocket, configured with given port.
 */
- (instancetype)initWithPort:(int)port;

/**
    @brief Designated initializer, creates and configures SSLServerSocket.
    @discussion Creates and configures SSL Server Socket with given port and delegate.

    Configuring may be failed while using BSD Sockets API (calls: socket(), bind() and listen()). Errors will be displayed in console.
 
    @param port - number between 1 and 65535 which will be retained as Socket port.
    @param delegate - will manage received messages. Notification will send to delegate when Socket will receive new message.
    @return SSLServerSocket, configured with given port.
 */
- (instancetype)initWithPort:(int)port andDelegate:(nullable id <SSLSocketDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
