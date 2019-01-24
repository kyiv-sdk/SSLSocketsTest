//
//  SSLLogger.h
//  SSLSockets
//
//  Created by Oleksandr Hordiienko on 1/23/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#ifndef SSLLogger_hpp
#define SSLLogger_hpp

#include <thread>
#include "ILoggable.h"
#include "LoggingPriorities.h"

class SSLLogger {
    
private:
    ILoggable *logger;
    LoggingPriority minPrioity;
    
    SSLLogger(ILoggable *logger, LoggingPriority minLogPriority);
    
    static std::mutex mtxSingletone;
    static SSLLogger *_sharedInstance;
    
public:
    void log(LoggingPriority priority, std::string message);
    void logSSLError(std::string message, long errorCode);
    void logERRNO(std::string message);
    
    static SSLLogger *sharedInstance();
    static void configureWith(ILoggable *logger, LoggingPriority minLogPriority);
};

#endif /* SSLLogger_hpp */
