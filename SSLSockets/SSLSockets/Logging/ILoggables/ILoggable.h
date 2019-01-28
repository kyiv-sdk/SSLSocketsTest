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

class ILoggable {
    
public:
    virtual void log(std::string message) = 0;
    virtual ~ILoggable() = default;
};

#endif /* ILoggable_h */
