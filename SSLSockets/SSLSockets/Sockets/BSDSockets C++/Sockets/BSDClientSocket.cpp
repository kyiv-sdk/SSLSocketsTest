//
//  BSDClientSocket.cpp
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/15/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#include "unistd.h"
#include "arpa/inet.h"
#include "netinet/in.h"
#include "sys/socket.h"
#include "CSSLLogger.h"
#include "Constants.h"
#include "BSDClientSocket.h"

bool BSDClientSocket::startSocket() {
    if (_isRunning) {
        CSSLLogger::log(WARNING, "BSDClientSocket -> cannot start socket. It has already started.");
        return true;
    }
    if (!_isReady) {
        CSSLLogger::log(ERROR, "BSDClientSocket -> cannot start socket. An error has been occurred while configuring.");
        return false;
    }
    CSSLLogger::log(LOG, "BSDClientSocket -> socket started.");
    handler->startHandling();
    _isRunning = true;
    return true;
}


void BSDClientSocket::stopSocket() {
    CSSLLogger::log(LOG, "BSDClientSocket -> socket will stopped.");
    _isRunning = false;
    if (handler) {
        CSSLLogger::log(LOG, "BSDClientSocket -> socket will delete its handler.");
        delete handler;
        handler = NULL;
        CSSLLogger::log(LOG, "BSDClientSocket -> socket has deleted its handler.");
    }
    CSSLLogger::log(LOG, "BSDClientSocket -> socket has stopped.");
}


bool BSDClientSocket::sendData(const char *data) {
    if (!_isRunning) {
        CSSLLogger::log(WARNING, "BSDClientSocket -> cannot send message. Socket isn't running.");
        return false;
    }
    CSSLLogger::log(LOG, "BSDClientSocket -> will send message to server.");
    return handler->send(data);
}


const std::vector<std::string> BSDClientSocket::getReceivedInfo() {
    CSSLLogger::log(LOG, "BSDClientSocket -> receivedInfo asked.");
    return handler->getReceivedInfo();
}



BSDClientSocket::BSDClientSocket(int port) : BSDClientSocket("127.0.0.1", port, NULL) { }
BSDClientSocket::BSDClientSocket(int port, BSDSocketDelegate *delegate) : BSDClientSocket("127.0.0.1", port, delegate) { }
BSDClientSocket::BSDClientSocket(std::string address, int port, BSDSocketDelegate *delegate) : BSDSocket(address, port, delegate) {
    CSSLLogger::log(LOG, "BSDClientSocket -> constructor called.");
    int descriptor = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (descriptor == FAIL_CODE) {
        CSSLLogger::logERRNO("BSDClientSocket -> Socket creation failed");
        _isReady = false;
    } else {
        CSSLLogger::log(LOG, "BSDClientSocket -> Socket successfully created.");
    }
    
    struct sockaddr_in sock_addr;
    memset(&sock_addr, 0, sizeof(sock_addr));
    sock_addr.sin_len = sizeof(sock_addr);
    sock_addr.sin_family = AF_INET;
    sock_addr.sin_port = htons(port);
    _isReady = (bool)inet_pton(AF_INET, address.c_str(), &sock_addr.sin_addr);
    
    CSSLLogger::log(LOG, "BSDClientSocket -> connecting to given address.");
    if (connect(descriptor, (struct sockaddr *)&sock_addr, sizeof(sock_addr)) == FAIL_CODE) {
        CSSLLogger::logERRNO("BSDClientSocket -> connection failed");
        close(descriptor);
        _isReady = false;
    } else {
        CSSLLogger::log(LOG, "BSDClientSocket -> has successfully connected to given address.");
    }
    
    CSSLLogger::log(LOG, "BSDClientSocket -> will create SSL Context.");
    SSL_CTX *ctx = SSL_CTX_new(TLS_client_method());
    CSSLLogger::log(LOG, "BSDClientSocket -> created SSL Context.");
    
    CSSLLogger::log(LOG, "BSDClientSocket -> will create SSL using SSL Context.");
    SSL* ssl = SSL_new(ctx);
    if (!ssl) {
        CSSLLogger::logERRNO("BSDClientSocket -> SSL creation failed");
        _isReady = false;
    } else {
        CSSLLogger::log(LOG, "BSDClientSocket -> created SSL using SSL Context.");
    }
    
    CSSLLogger::log(LOG, "BSDClientSocket -> getting FD from created SSL.");
    socketDescriptor = SSL_get_fd(ssl);
    CSSLLogger::log(LOG, "BSDClientSocket -> setting FD from created socket to SSL.");
    SSL_set_fd(ssl, descriptor);
    int err = SSL_connect(ssl);
    if (err <= 0) {
        _isReady = false;
        int errorCode = SSL_get_error(ssl, err);
        CSSLLogger::logSSLError("BSDSocketHandler -> SSL_connect failed", errorCode);
    } else {
        CSSLLogger::log(LOG, "BSDClientSocket -> successfully configured and connected.");
        handler = new BSDSocketHandler(ssl, descriptor, delegate, NULL);
    }
}


BSDClientSocket::~BSDClientSocket() {
    CSSLLogger::log(LOG, "BSDClientSocket -> destructor called.");
    this->stopSocket();
}
