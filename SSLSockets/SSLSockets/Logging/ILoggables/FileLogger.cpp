//
//  FileLogger.cpp
//  SSLSockets
//
//  Created by Oleksandr Hordiienko on 1/23/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#include "FileLogger.h"
#include "FileManagement.h"

void FileLogger::startRunLoop() {
    std::unique_lock<std::mutex> lck(mtxQueue);
    while (isLogging) {
        notifier.wait(lck);
        while (pendingQueue.size() > 0) {
            std::string message(pendingQueue.front());
            fprintf(logfile, "%s\n", message.c_str());
            pendingQueue.erase(pendingQueue.begin());
        }
    }
}


void FileLogger::startLogging() {
    if (isLogging || !logfile) return;
    isLogging = true;
    retainedThread = std::thread(&FileLogger::startRunLoop, this);
}


void FileLogger::log(std::string message) {
    pendingQueue.push_back(message);
    notifier.notify_all();
}



FileLogger::FileLogger(std::string filename) {
    isLogging = false;
    logfile = iosfopen(filename.c_str(), "a+");
    if (logfile) {
        std::string message = "\n ********** NEW SESSION STARTED ********** ";
        fprintf(logfile, "%s\n", message.c_str());
    } else {
        printf("Cannot open file for logging.\n");
    }
}


FileLogger::~FileLogger() {
    log(std::string(" ********** SESSION ENDED ********** \n"));
    fflush(logfile);
    isLogging = false;
    notifier.notify_all();
    if (retainedThread.joinable()) retainedThread.join();
    fclose(logfile);
}
