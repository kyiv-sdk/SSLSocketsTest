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

std::vector<ILoggable *> SSLLogger::loggers;


void SSLLogger::addLogger(ILoggable *logger) {
    loggers.push_back(logger);
}


void SSLLogger::removeLoggerWithIdentifier(std::string identifier) {
    loggers.erase(std::remove_if(begin(loggers), end(loggers), [identifier](ILoggable *logger)
    {
        return logger->identifier == identifier;
    }), end(loggers));
}


void SSLLogger::stopLogging() {
    for (ILoggable *logger : loggers) {
        if (logger) delete logger;
    }
}


void SSLLogger::log(LoggingPriority priority, std::string message) {
    auto now = std::chrono::system_clock::now();
    std::time_t time_t_now = std::chrono::system_clock::to_time_t(now);
    std::string time = std::ctime(&time_t_now);
    std::string logMessage = time.substr(0, time.size()-1) + ": " + message;
    for (ILoggable *logger : loggers) {
        logger->log(priority, logMessage);
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
