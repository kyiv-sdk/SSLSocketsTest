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
    void log(std::string message) override;
    
};

#endif /* ConsoleLogger_hpp */
