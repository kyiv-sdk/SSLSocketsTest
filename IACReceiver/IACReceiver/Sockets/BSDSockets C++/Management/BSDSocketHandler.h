//
//  BSDSocketHandler.h
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/15/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#ifndef BSDSocketHandler_h
#define BSDSocketHandler_h

#include <vector>
#include <thread>
#include <stdio.h>
#include "openssl/ssl.h"
#include "BSDSocketDelegate.h"
#import "IBSDHandlersManager.h"

class BSDSocketHandler {
    
private:
    SSL *ssl;
    int descriptor;
    bool _isHandling;
    std::thread retainedThread;
    IBSDHandlersManager *manager;
    BSDSocketDelegate *delegate;
    std::vector<std::string> receivedInfo;
    
    void startReading();
    char *readData();
    
public:
    const SSL *getSSL();
    bool isHandling();
    void startHandling();
    void stopHandling();
    bool send(const char *data);
    const std::vector<std::string> getReceivedInfo();
    
    BSDSocketHandler(SSL* ssl, int descriptor, BSDSocketDelegate *delegate, IBSDHandlersManager *manager);
    ~BSDSocketHandler();
    
};

#endif /* BSDSocketHandler_h */
