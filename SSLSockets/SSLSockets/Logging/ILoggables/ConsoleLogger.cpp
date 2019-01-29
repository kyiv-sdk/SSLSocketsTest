//
//  ConsoleLogger.cpp
//  SSLSockets
//
//  Created by Oleksandr Hordiienko on 1/23/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#include "ConsoleLogger.h"

void ConsoleLogger::log(LoggingPriority priority, std::string message) {
    if (priority < minPriority) return;
    printf("%s\n", message.c_str());
}


ConsoleLogger::ConsoleLogger(std::string identifier, LoggingPriority minPriority) {
    this->identifier = identifier;
    this->minPriority = minPriority;
}


ConsoleLogger::~ConsoleLogger() {}
