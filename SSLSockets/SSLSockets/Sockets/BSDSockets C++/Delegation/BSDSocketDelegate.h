//
//  BSDSocketDelegate.h
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/15/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#ifndef BSDSocketDelegate_h
#define BSDSocketDelegate_h

#include <string>
#include "openssl/ssl.h"

class BSDSocketDelegate {
    
public:
    void *objcDelegate;
    
    void didReceiveMessage(std::string message, SSL* ssl);
    
    BSDSocketDelegate(void *objcDelegate);
    ~BSDSocketDelegate();
    
};

#endif /* BSDSocketDelegate_h */
