//
//  SSLLoggable.h
//  SSLSockets
//
//  Created by Oleksandr Hordiienko on 1/30/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, SSLLoggingPriority) {
    SSLLoggingPriorityLog,
    SSLLoggingPriorityWarning,
    SSLLoggingPriorityError,
    SSLLoggingPriorityFatalError
};


NS_ASSUME_NONNULL_BEGIN

@protocol SSLLoggable <NSObject>

/**
    @brief Minimal priority of logs that will be handled by destination.
 */
@property (assign, nonatomic) SSLLoggingPriority minPriority;

/**
    @brief Called each time SSLLogger receives message to log smth.
    @discussion Will be called only with priorities equals or greater that 'minPriority' property.
    @param message - log message that should be logged.
    @param priority - priority of received log message.
 */
- (void)logMessage:(NSString *)message withPriority:(SSLLoggingPriority)priority;

@end

NS_ASSUME_NONNULL_END
