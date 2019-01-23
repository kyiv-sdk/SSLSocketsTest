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
    
    SSLLogger(ILoggable *logger);
    
    static std::mutex mtxSingletone;
    static SSLLogger *_sharedInstance;
    
public:
    void log(LoggingPriority priority, std::string message);
    
    static SSLLogger *sharedInstance();
    static void configureWith(ILoggable *logger);
};

#endif /* SSLLogger_hpp */
