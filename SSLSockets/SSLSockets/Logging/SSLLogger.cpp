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

void SSLLogger::log(LoggingPriority priority, std::string message) {
    if (priority < minPrioity) return;
    
    auto now = std::chrono::system_clock::now();
    std::time_t time_t_now = std::chrono::system_clock::to_time_t(now);
    std::string time = std::ctime(&time_t_now);
    std::string logMessage = time.substr(0, time.size()-1) + ": " + message;
    logger->log(logMessage);
}


void SSLLogger::logSSLError(std::string message, long errorCode) {
    std::string errMsg = message + std::string(": ") + ERR_error_string(errorCode, NULL);
    SSLLogger::sharedInstance()->log(ERROR, errMsg);
}


void SSLLogger::logERRNO(std::string message) {
    std::string errorMsg = message + std::string(": ") + strerror(errno);
    SSLLogger::sharedInstance()->log(ERROR, errorMsg);
}



SSLLogger::SSLLogger(ILoggable *logger, LoggingPriority minLogPriority) {
    this->logger = logger;
    minPrioity = minLogPriority;
}



std::mutex SSLLogger::mtxSingletone;
SSLLogger *SSLLogger::_sharedInstance = NULL;
SSLLogger *SSLLogger::sharedInstance() {
    mtxSingletone.lock();
    if (_sharedInstance) {
        mtxSingletone.unlock();
        return _sharedInstance;
    }
    
    _sharedInstance = new SSLLogger(new ConsoleLogger(), LOG);
    mtxSingletone.unlock();
    return _sharedInstance;
}


void SSLLogger::configureWith(ILoggable *logger, LoggingPriority minLogPriority) {
    mtxSingletone.lock();
    _sharedInstance = new SSLLogger(logger, minLogPriority);
    mtxSingletone.unlock();
}
