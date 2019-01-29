//
//  SSLLogger.cpp
//  SSLSockets
//
//  Created by Oleksandr Hordiienko on 1/23/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#include <ctime>
#include <chrono>
#include "SSLLogger.h"
#include <openssl/err.h>
#include "ConsoleLogger.h"

std::map<std::string, ILoggable *> SSLLogger::loggers;


void SSLLogger::addLogger(ILoggable *logger, std::string identifier) {
    ILoggable *oldLogger = loggers[identifier];
    if (oldLogger) delete oldLogger;
    loggers[identifier] = logger;
}


void SSLLogger::removeLoggerWithIdentifier(std::string identifier) {
    ILoggable *logger = loggers[identifier];
    if (logger) {
        delete logger;
        loggers.erase(identifier);
    }
}


void SSLLogger::removeLoggersWithClassIdentifier(std::string identifier) {
    for (auto it = loggers.cbegin(); it != loggers.cend(); /* no increment */) {
        ILoggable *logger = it->second;
        if (logger->classIdentifier == identifier) {
            if (logger) delete logger;
            loggers.erase(it++);
        } else {
            ++it;
        }
    }
}

void SSLLogger::stopLogging() {
    for (auto it = loggers.cbegin(); it != loggers.cend(); /* no increment */) {
        ILoggable *logger = it->second;
        if (logger) delete logger;
        loggers.erase(it++);
    }
}


void SSLLogger::log(LoggingPriority priority, std::string message) {
    auto now = std::chrono::system_clock::now();
    std::time_t time_t_now = std::chrono::system_clock::to_time_t(now);
    std::string time = std::ctime(&time_t_now);
    std::string logMessage = time.substr(0, time.size()-1) + ": " + message;
    
    for (std::map<std::string, ILoggable *>::iterator it = loggers.begin(); it != loggers.end(); ++it) {
        it->second->log(priority, message);
    }
}


void SSLLogger::logSSLError(std::string message, long errorCode) {
    std::string errMsg = message + std::string(": ") + ERR_error_string(errorCode, NULL);
    SSLLogger::log(ERROR, errMsg);
}


void SSLLogger::logERRNO(std::string message) {
    std::string errorMsg = message + std::string(": ") + strerror(errno);
    SSLLogger::log(ERROR, errorMsg);
}
