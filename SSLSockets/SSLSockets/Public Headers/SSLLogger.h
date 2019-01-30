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

+ (void)addLoggingDestination:(id<SSLLoggable>)destination withIdentifier:(NSString *)identifier;

+ (void)addLoggingInFile:(NSFileHandle *)file withIdentifier:(NSString *)identifier andMinimalPriority:(SSLLoggingPriority)priority;

+ (void)addLoggingInFileWithName:(NSString *)name withIdentifier:(NSString *)identifier andMinimalPriority:(SSLLoggingPriority)priority;

+ (void)removeLoggerWithSSLLoggableClass:(__unsafe_unretained Class)loggableClass;

+ (void)removeLoggerWithIdentifier:(NSString *)identifier;

+ (void)stopLogging;

@end

NS_ASSUME_NONNULL_END
