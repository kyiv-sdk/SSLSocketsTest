//
//  FileLogger.h
//  SSLSockets
//
//  Created by Oleksandr Hordiienko on 1/23/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#ifndef FileLogger_h
#define FileLogger_h

#include <thread>
#include <vector>
#include "ILoggable.h"

class FileLogger: public ILoggable {

private:
    bool isLogging;
    FILE *logfile;
    std::thread retainedThread;
    std::vector<std::string> pendingQueue;
    std::mutex mtxQueue;
    std::condition_variable notifier;
    
    void startRunLoop();
    
public:
    void startLogging();
    void log(LoggingPriority priority, std::string message) override;
    
    FileLogger(LoggingPriority minPriority, std::string filename);
    FileLogger(LoggingPriority minPriority, FILE *logfile);
    ~FileLogger() override;
};

#endif /* FileLogger_h */
