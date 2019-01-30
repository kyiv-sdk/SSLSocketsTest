//
//  CSSLLogger.h
//  SSLSockets
//
//  Created by Oleksandr Hordiienko on 1/23/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#ifndef SSLLogger_h
#define SSLLogger_h

#include <map>
#include "ILoggable.h"
#include "LoggingPriorities.h"

class CSSLLogger {
    
private:
    static std::map<std::string, ILoggable *> loggers;
    
public:
    static const std::map<std::string, ILoggable *> getLoggers();
    static void addLogger(ILoggable *logger, std::string identifier);
    static void removeLoggerWithIdentifier(std::string identifier);
    static void removeLoggersWithClassIdentifier(std::string identifier);
    static void stopLogging();
    
    static void log(LoggingPriority priority, std::string message);
    static void logSSLError(std::string message, long errorCode);
    static void logERRNO(std::string message);
    
};

#endif /* SSLLogger_h */
