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
    static ILoggable *logger;
    
public:
    static LoggingPriority minPrioity;
    
    static void setLogger(ILoggable *logger);
    static void log(LoggingPriority priority, std::string message);
    static void logSSLError(std::string message, long errorCode);
    static void logERRNO(std::string message);
    
};

#endif /* SSLLogger_hpp */
