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

#pragma mark - Methods
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

#pragma mark - Constructor
HighLevelLogger::HighLevelLogger(void *logger, LoggingPriority minPriority) {
    this->loggerObj = logger;
    this->minPriority = minPriority;
}

#pragma mark - Destructor
HighLevelLogger::~HighLevelLogger() {
    CFRelease(loggerObj);
}
