//
//  ConsoleLogger.cpp
//  SSLSockets
//
//  Created by Oleksandr Hordiienko on 1/23/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#include "ConsoleLogger.h"

void ConsoleLogger::log(LoggingPriority priority, std::string message) {
    if (priority < minPrioity) return;
    printf("%s\n", message.c_str());
}


ConsoleLogger::ConsoleLogger(LoggingPriority minPriority) {
    this->minPrioity = minPrioity;
}


ConsoleLogger::~ConsoleLogger() {}
