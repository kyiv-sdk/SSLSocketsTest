//
//  HighLevelLogger.cpp
//  SSLSockets
//
//  Created by Oleksandr Hordiienko on 1/30/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#include "SSLLoggable.h"
#include "HighLevelLogger.h"
#include <Foundation/Foundation.h>

void HighLevelLogger::log(LoggingPriority priority, std::string message) {
    id<SSLLoggable> logger = (__bridge id<SSLLoggable>)loggerObj;
    
    // Converting priority
    int intPriority = static_cast<int>(priority);
    SSLLoggingPriority lpriority = (SSLLoggingPriority)intPriority;
    if (lpriority < logger.minPriority) return;
    
    // Converting log message
    const char *msg = message.c_str();
    NSStringEncoding encoding = [NSString defaultCStringEncoding];
    NSString *messageToLog = [NSString stringWithCString:msg encoding:encoding];
    
    // Redirecting log to HighLevel Logger
    [logger logMessage:messageToLog withPriority:lpriority];
}

#pragma mark LifeCycle
HighLevelLogger::HighLevelLogger(void *logger, std::string classIdentifier, LoggingPriority minPriority) {
    this->loggerObj = logger;
    this->minPriority = minPriority;
    this->classIdentifier = classIdentifier;
}

HighLevelLogger::~HighLevelLogger() {
    CFRelease(loggerObj);
}
