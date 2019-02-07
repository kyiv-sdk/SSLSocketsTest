//
//  BSDServerSocket.h
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/15/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#ifndef BSDServerSocket_h
#define BSDServerSocket_h

#include "BSDSocket.h"
#include "BSDSocketHandler.h"

class BSDServerSocket: public BSDSocket, public IBSDHandlersManager {
    
private:
    SSL_CTX *sslContext;
    std::thread retainedThread;
    std::vector<BSDSocketHandler *> acceptedSockets;
    
    void waitForConnections();
    
public:
    bool startSocket() override;
    void stopSocket() override;
    bool sendData(const char *data, SSL const *ssl);
    const std::vector<BSDSocketHandler *> getAcceptedSockets();
    
    void didStopHandler(BSDSocketHandler *handler) override;
    
    BSDServerSocket(int port);
    BSDServerSocket(int port, BSDSocketDelegate *delegate);
    ~BSDServerSocket();
    
};

#endif /* BSDServerSocket_h */
