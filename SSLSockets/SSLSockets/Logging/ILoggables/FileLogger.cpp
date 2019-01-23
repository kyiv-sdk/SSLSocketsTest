//
//  FileLogger.cpp
//  SSLSockets
//
//  Created by Oleksandr Hordiienko on 1/23/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#include "FileLogger.h"
#include "FileManagement.h"

void FileLogger::log(std::string message) {
    mtx.lock();
    FILE *logfile = iosfopen(filename.c_str(), "wb+");
    if (logfile) {
        fprintf(logfile, "%s", message.c_str());
        fclose(logfile);
    } else {
        printf("Cannot open file for logging!\n");
    }
    mtx.unlock();
}



FileLogger::FileLogger(std::string filename) {
    this->filename = filename;
}
