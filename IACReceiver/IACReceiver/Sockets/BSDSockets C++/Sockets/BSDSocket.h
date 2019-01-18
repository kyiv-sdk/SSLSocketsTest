//
//  BSDSocket.h
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/15/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#ifndef BSDSocket_h
#define BSDSocket_h

#include <vector>
#include "BSDSocketDelegate.h"


class BSDSocket {
  
protected:
    bool _isReady;
    bool _isRunning;
    int socketDescriptor;
    
public:
    const int port;
    const bool isReady();
    const bool isRunning();
    const std::string address;
    BSDSocketDelegate *delegate;

    virtual bool startSocket() = 0;
    virtual void stopSocket() = 0;
    virtual const std::vector<std::string> getReceivedInfo() = 0;
    
    BSDSocket(std::string address, int port, BSDSocketDelegate *delegate);
    
};

#endif /* BSDSocket_h */
