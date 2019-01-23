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
#include "ConsoleLogger.h"

void SSLLogger::log(LoggingPriority priority, std::string message) {
    if (priority < minPrioity) return;
    
    auto now = std::chrono::system_clock::now();
    std::time_t time_t_now = std::chrono::system_clock::to_time_t(now);
    std::string time = std::ctime(&time_t_now);
    std::string logMessage = time + ": " + message;
    logger->log(logMessage);
}



SSLLogger::SSLLogger(ILoggable *logger) {
    this->logger = logger;
}



std::mutex SSLLogger::mtxSingletone;
SSLLogger *SSLLogger::_sharedInstance = NULL;
SSLLogger *SSLLogger::sharedInstance() {
    mtxSingletone.lock();
    if (_sharedInstance) {
        mtxSingletone.unlock();
        return _sharedInstance;
    }
    
    _sharedInstance = new SSLLogger(new ConsoleLogger());
    mtxSingletone.unlock();
    return _sharedInstance;
}


void SSLLogger::configureWith(ILoggable *logger) {
    mtxSingletone.lock();
    _sharedInstance = new SSLLogger(logger);
    mtxSingletone.unlock();
}
