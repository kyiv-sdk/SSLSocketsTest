//
//  SSLSocket.h
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/11/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSLSocketDelegate+Protected.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSLSocket : NSObject

/**
    @brief Returns a Boolean value indicating configuring success.
    @discussion Value YES returns in case of successful configuring, value NO returns in case of any BSD Sockets API functions was failed. Means impossibility of current object using.
 */
@property (assign, nonatomic, readonly) BOOL isReady;

/**
    @brief Returns a Boolean value indicating state of socket.
    @discussion
        Value YES may be returned only in case Socket is successfully configured, already started and ready to send/receive messages.
 
        Value NO may be returned in following cases:
            * error occured while Socket configuring and that is why it cannot be runned (check isReady property);
            * socket was configured but not already started (use Start method to start it);
            * socket already closed: suspended state before destroying object.
 */
@property (assign, nonatomic, readonly) BOOL isRunning;

/**
    @brief Socket's port.
 */
@property (assign, nonatomic, readonly) int port;

/**
    @brief Socket's address.
 */
@property (strong, nonatomic, readonly) NSString *address;

/**
    @brief Storage of received messages.
 */
@property (strong, nonatomic, readonly) NSArray *receivedInfo;

/**
    @brief Manages received messages. Notification will send to delegate when Socket will receive new message.
 */
@property (weak, nonatomic, readwrite) SSLSocketDelegate *delegate;



/**
    @brief Starts Socket, makess it ready to send/receive messages.
    @return YES if the receiver was successfully configured and being started or NO if it is not.
 */
- (BOOL)startSocket;


/**
    @brief Closes Socket and frees memory, makes it impossible to reuse.
 */
- (void)stopSocket;

@end

NS_ASSUME_NONNULL_END



