//
//  SSLLogger.h
//  SSLSockets
//
//  Created by Oleksandr Hordiienko on 1/23/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#ifndef SSLLogger_hpp
#define SSLLogger_hpp

#include <map>
#include "ILoggable.h"
#include "LoggingPriorities.h"

class SSLLogger {
    
private:
    static std::map<std::string, ILoggable *> loggers;
    
public:
    static void addLogger(ILoggable *logger, std::string identifier);
    static void removeLoggerWithIdentifier(std::string identifier);
    static void removeLoggersWithClassIdentifier(std::string identifier);
    static void stopLogging();
    
    static void log(LoggingPriority priority, std::string message);
    static void logSSLError(std::string message, long errorCode);
    static void logERRNO(std::string message);
    
};

#endif /* SSLLogger_hpp */
