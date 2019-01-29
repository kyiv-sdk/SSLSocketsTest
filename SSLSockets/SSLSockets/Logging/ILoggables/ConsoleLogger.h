//
//  ConsoleLogger.h
//  SSLSockets
//
//  Created by Oleksandr Hordiienko on 1/23/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#ifndef ConsoleLogger_hpp
#define ConsoleLogger_hpp

#include "ILoggable.h"

class ConsoleLogger : public ILoggable {

public:
    void log(LoggingPriority priority, std::string message) override;
    
    ConsoleLogger(std::string identifier, LoggingPriority minPriority);
    ~ConsoleLogger() override;
};

#endif /* ConsoleLogger_hpp */
