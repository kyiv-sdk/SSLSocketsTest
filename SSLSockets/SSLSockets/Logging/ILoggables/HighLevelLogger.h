//
//  HighLevelLogger.h
//  SSLSockets
//
//  Created by Oleksandr Hordiienko on 1/30/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#ifndef HighLevelLogger_h
#define HighLevelLogger_h

#include "ILoggable.h"

class HighLevelLogger: public ILoggable {
    
private:
    void *loggerObj;
    
public:
    void log(LoggingPriority priority, std::string message) override;
    
    HighLevelLogger(void *logger, LoggingPriority minPriority);
    ~HighLevelLogger() override;
    
};

#endif /* HighLevelLogger_h */
