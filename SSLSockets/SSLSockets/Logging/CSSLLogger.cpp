//
//  CSSLLogger.cpp
//  SSLSockets
//
//  Created by Oleksandr Hordiienko on 1/23/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#include <ctime>
#include <chrono>
#include <thread>
#include <sstream>
#include "CSSLLogger.h"
#include <openssl/err.h>
#include "ConsoleLogger.h"

std::map<std::string, ILoggable *> CSSLLogger::loggers;

#pragma mark Loggers Management Methods
void CSSLLogger::addLogger(ILoggable *logger, std::string key) {
    ILoggable *oldLogger = loggers[key];
    if (oldLogger) delete oldLogger;
    loggers[key] = logger;
}

void CSSLLogger::removeLoggerWithKey(std::string key) {
    ILoggable *logger = loggers[key];
    if (logger) {
        delete logger;
        loggers.erase(key);
    }
}

void CSSLLogger::removeAllLoggers() {
    for (auto it = loggers.cbegin(); it != loggers.cend(); /* no increment */) {
        ILoggable *logger = it->second;
        if (logger) delete logger;
        loggers.erase(it++);
    }
}

#pragma mark Logging Methods
void CSSLLogger::log(LoggingPriority priority, std::string message) {
    // Current Time
    auto now = std::chrono::system_clock::now();
    std::time_t time_t_now = std::chrono::system_clock::to_time_t(now);
    std::string time = std::ctime(&time_t_now);
    
    // Current Thread
    std::thread::id curentThread = std::this_thread::get_id();
    std::stringstream ss;
    ss << curentThread;
    std::string stringThread = "(Thread " + ss.str() + "): ";
    
    // Redirecting to ILoggables
    std::string logMessage = time.substr(0, time.size()-1) + ": " + stringThread + message;
    for (std::map<std::string, ILoggable *>::iterator it = loggers.begin(); it != loggers.end(); ++it) {
        it->second->log(priority, logMessage);
    }
}


void CSSLLogger::logSSLError(std::string message, long errorCode) {
    std::string errMsg = message + std::string(": ") + ERR_error_string(errorCode, NULL);
    CSSLLogger::log(ERROR, errMsg);
}


void CSSLLogger::logERRNO(std::string message) {
    std::string errorMsg = message + std::string(": ") + strerror(errno);
    CSSLLogger::log(ERROR, errorMsg);
}
