//
//  ConsoleLogger.cpp
//  SSLSockets
//
//  Created by Oleksandr Hordiienko on 1/23/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#include "ConsoleLogger.h"

void ConsoleLogger::log(std::string message) {
    printf("%s\n", message.c_str());
}


ConsoleLogger::~ConsoleLogger() {}
