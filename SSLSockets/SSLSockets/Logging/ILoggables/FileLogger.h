//
//  FileLogger.h
//  SSLSockets
//
//  Created by Oleksandr Hordiienko on 1/23/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#ifndef FileLogger_hpp
#define FileLogger_hpp

#include <thread>
#include "ILoggable.h"

class FileLogger: public ILoggable {

private:
    std::mutex mtx;
    std::string filename;
    
public:
    void log(std::string message) override;
    
    FileLogger(std::string filename);
    
};

#endif /* FileLogger_hpp */
