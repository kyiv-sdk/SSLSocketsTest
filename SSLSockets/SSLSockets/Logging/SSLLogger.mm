//
//  SSLLogger.m
//  SSLSockets
//
//  Created by Oleksandr Hordiienko on 1/30/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "SSLLogger.h"
#import "CSSLLogger.h"
#import "FileLogger.h"
#import "HighLevelLogger.h"

@implementation SSLLogger

#pragma mark Logging
+ (void)logMessage:(NSString *)message withPriority:(SSLLoggingPriority)priority {
    LoggingPriority lpriority = LoggingPriority(priority);
    std::string lmessage([message UTF8String]);
    CSSLLogger::log(lpriority, lmessage);
}

#pragma mark Loggers Management Methods
+ (void)addLoggingDestination:(id<SSLLoggable>)destination {
    NSString *objectHash = [NSString stringWithFormat:@"%li", [destination hash]];
    LoggingPriority lpriority = LoggingPriority(destination.minPriority);
    void *loggerObj = (void *)CFBridgingRetain(destination);
    HighLevelLogger *logger = new HighLevelLogger(loggerObj, lpriority);
    std::string key([objectHash UTF8String]);
    CSSLLogger::addLogger(logger, key);
}

+ (void)removeLoggingDestination:(id<SSLLoggable>)destination {
    NSString *objectHash = [NSString stringWithFormat:@"%li", [destination hash]];
    std::string key([objectHash UTF8String]);
    CSSLLogger::removeLoggerWithKey(key);
}

+ (void)removeAllLoggingDestinations {
    CSSLLogger::removeAllLoggers();
}

@end
