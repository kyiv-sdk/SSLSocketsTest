//
//  BSDSocket.cpp
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/15/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#include "CSSLLogger.h"
#include "BSDSocket.h"
#include "SSLSigningManager.h"

const bool BSDSocket::isReady() {
    return _isReady;
}


const bool BSDSocket::isRunning() {
    return _isRunning;
}


BSDSocket::BSDSocket(std::string address, const int port, BSDSocketDelegate *delegate) : port(port), address(address) {
    _isReady = true;
    _isRunning = false;
    this->delegate = delegate;
    SSLSigningManager::sharedInstance()->initSSLLibrary();
    CSSLLogger::log(LOG, "BSDSocket -> instance created.");
}
