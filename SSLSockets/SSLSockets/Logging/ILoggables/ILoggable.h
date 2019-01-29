//
//  ILoggable.h
//  SSLSockets
//
//  Created by Oleksandr Hordiienko on 1/23/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#ifndef ILoggable_h
#define ILoggable_h

#include <string>
#include "LoggingPriorities.h"

class ILoggable {
    
public:
    std::string identifier;
    LoggingPriority minPriority;
    
    virtual void log(LoggingPriority priority, std::string message) = 0;
    
    virtual ~ILoggable() = default;
};

#endif /* ILoggable_h */
