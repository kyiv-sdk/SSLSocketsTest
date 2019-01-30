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

+ (void)logMessage:(NSString *)message withPriority:(SSLLoggingPriority)priority;

+ (void)addLoggingDestination:(id<SSLLoggable>)destination;

+ (void)removeLoggingDestination:(id<SSLLoggable>)destination;

+ (void)removeAllLoggingDestinations;

@end

NS_ASSUME_NONNULL_END
