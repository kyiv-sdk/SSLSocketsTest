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

#pragma mark Add Destination
+ (void)addLoggingDestination:(id<SSLLoggable>)destination withIdentifier:(NSString *)identifier {
    std::string lidentifier([identifier UTF8String]);
    NSString *className = NSStringFromClass([destination class]);
    std::string classIdentifier([className UTF8String]);
    LoggingPriority lpriority = LoggingPriority(destination.minPriority);
    void *loggerObj = (void *)CFBridgingRetain(destination);
    HighLevelLogger *logger = new HighLevelLogger(loggerObj, classIdentifier, lpriority);
    CSSLLogger::addLogger(logger, lidentifier);
}

+ (void)addLoggingInFile:(NSFileHandle *)file withIdentifier:(NSString *)identifier andMinimalPriority:(SSLLoggingPriority)priority {
    LoggingPriority lpriority = LoggingPriority(priority);
    std::string lidentifier([identifier UTF8String]);
    FILE *fd = fdopen([file fileDescriptor], "a+");
    FileLogger *logger = new FileLogger(lpriority, fd);
    CSSLLogger::addLogger(logger, lidentifier);
    logger->startLogging();
}

+ (void)addLoggingInFileWithName:(NSString *)name withIdentifier:(NSString *)identifier andMinimalPriority:(SSLLoggingPriority)priority {
    LoggingPriority lpriority = LoggingPriority(priority);
    std::string lidentifier([identifier UTF8String]);
    std::string filename([name UTF8String]);
    FileLogger *logger = new FileLogger(lpriority, filename);
    CSSLLogger::addLogger(logger, lidentifier);
    logger->startLogging();
}

#pragma mark Remove Destination
+ (void)removeLoggerWithSSLLoggableClass:(__unsafe_unretained Class)loggableClass {
    NSString *className = NSStringFromClass(loggableClass);
    std::string classIdentifier([className UTF8String]);
    CSSLLogger::removeLoggersWithClassIdentifier(classIdentifier);
}

+ (void)removeLoggerWithIdentifier:(NSString *)identifier {
    std::string lidentifier([identifier UTF8String]);
    CSSLLogger::removeLoggerWithIdentifier(lidentifier);
}

+ (void)stopLogging {
    CSSLLogger::stopLogging();
}

@end
