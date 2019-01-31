//
//  SSLLogger.h
//  SSLSockets
//
//  Created by Oleksandr Hordiienko on 1/30/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "SSLLoggable.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSLLogger : NSObject

/**
    @brief Logs messages to destinations.
    @discussion Passed message will be logged to destinations with minimum log priority equals or lower than passed one.
    @param message - message that should be logged.
    @param priority - priority of loggable message.
 */
+ (void)logMessage:(NSString *)message withPriority:(SSLLoggingPriority)priority;

/**
    @brief Adds new logging destination.
    @param destination - any object thath implements 'SSLLoggable' protocol.
 */
+ (void)addLoggingDestination:(id<SSLLoggable>)destination;

/**
    @brief Removes passed destination from logging destinations pool.
    @param destination - object that should be removed from logging destinations pool.
 */
+ (void)removeLoggingDestination:(id<SSLLoggable>)destination;

/**
    @brief Removes all destinations from logging destinations pool.
 */
+ (void)removeAllLoggingDestinations;

@end

NS_ASSUME_NONNULL_END
