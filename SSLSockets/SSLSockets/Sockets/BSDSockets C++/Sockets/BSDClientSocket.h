//
//  BSDClientSocket.h
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/15/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#ifndef BSDClientSocket_h
#define BSDClientSocket_h

#include "BSDSocket.h"
#include "BSDSocketHandler.h"

class BSDClientSocket: public BSDSocket {
    
private:
    BSDSocketHandler *handler;
  
public:
    bool startSocket() override;
    void stopSocket() override;
    bool sendData(const char *data);
    const std::vector<std::string> getReceivedInfo() override;
    
    BSDClientSocket(int port);
    BSDClientSocket(int port, BSDSocketDelegate *delegate);
    BSDClientSocket(std::string address, int port, BSDSocketDelegate *delegate);
    ~BSDClientSocket();
    
};

#endif /* BSDClientSocket_h */
