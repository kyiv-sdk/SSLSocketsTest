//
//  SSLClientSocket.h
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/11/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "SSLSocket.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSLClientSocket : SSLSocket

/**
    @brief Sends given message to dedicated SSLServerSocket that it connected to.
    @param data - any information, converted to NSString *, that will be sent to dedicated SSLServerSocker.
    @return YES if message was successfully send or NO if Socket is not configured/not running (check isReady and isRunning properties).
 */
- (BOOL)sendData:(NSString *)data;


/**
    @brief Convenience initializer, creates and configures SSLClientSocket.
    @discussion Calls designated initializer, creates and configures SSL Client Socket for local SSLServerSocket with given port, will not have delegate (received messages will be ignored).
    @param port - number between 1 and 65535 which means dedicated SSLServerSocket port.
    @return SSLClientSocket, configured for local SSLServerSocket with given port.
 */
- (instancetype)initWithPort:(int)port;

/**
    @brief Convenience initializer, creates and configures SSL Client Socket.
    @discussion Calls designated initializer, creates and configures SSLClientSocket for local SSLServerSocket with given port and delegate.
    @param port - number between 1 and 65535 which means dedicated SSLServerSocket port.
    @param delegate - will manage received messages. Notification will send to delegate when Socket will receive new message.
    @return SSLClientSocket, configured for local SSLServerSocket with given port and delegate.
 */
- (instancetype)initWithPort:(int)port andDelegate:(SSLSocketDelegate *)delegate;

/**
    @brief Designated initializer, creates and configures SSLClientSocket.
    @discussion Creates and configures SSL Server Socket with given port and delegate.

    Configuring may be failed while using BSD Sockets API (calls: socket(), bind() and listen()). Errors will be displayed in console.

    @param address - IP of dedicated SSLServerSocket.
    @param port - number between 1 and 65535 which means dedicated SSLServerSocket port.
    @param delegate - will manage received messages. Notification will send to delegate when Socket will receive new message.
    @return SSLClientSocket, configured with given address, port and delegate.
 */
- (instancetype)initWithAddress:(NSString *)address port:(int)port andDelegate:(nullable SSLSocketDelegate *)delegate;

@end

NS_ASSUME_NONNULL_END
