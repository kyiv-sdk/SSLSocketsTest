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
#include "Constants.h"
#include "BSDClientSocket.h"

bool BSDClientSocket::startSocket() {
    if (_isRunning) return true;
    if (!_isReady) return false;
    handler->startHandling();
    _isRunning = true;
    return true;
}


void BSDClientSocket::stopSocket() {
    _isRunning = false;
    if (handler) {
        delete handler;
        handler = NULL;
    }
}


bool BSDClientSocket::sendData(const char *data) {
    if (!_isRunning) return false;
    return handler->send(data);
}


const std::vector<std::string> BSDClientSocket::getReceivedInfo() {
    return handler->getReceivedInfo();
}



BSDClientSocket::BSDClientSocket(int port) : BSDClientSocket("127.0.0.1", port, NULL) { }
BSDClientSocket::BSDClientSocket(int port, BSDSocketDelegate *delegate) : BSDClientSocket("127.0.0.1", port, delegate) { }
BSDClientSocket::BSDClientSocket(std::string address, int port, BSDSocketDelegate *delegate) : BSDSocket(address, port, delegate) {
    int descriptor = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (descriptor == FAIL_CODE) {
        perror("Cannot create ClientSocket");
        _isReady = false;
    }
    
    struct sockaddr_in sock_addr;
    memset(&sock_addr, 0, sizeof(sock_addr));
    sock_addr.sin_len = sizeof(sock_addr);
    sock_addr.sin_family = AF_INET;
    sock_addr.sin_port = htons(port);
    _isReady = (bool)inet_pton(AF_INET, address.c_str(), &sock_addr.sin_addr);
    
    if (connect(descriptor, (struct sockaddr *)&sock_addr, sizeof(sock_addr)) == FAIL_CODE) {
        perror("Cannot connect to ClientSocket");
        close(descriptor);
        _isReady = false;
    }
    
    SSL_CTX *ctx = SSL_CTX_new(TLSv1_2_client_method());
    
    SSL* ssl = SSL_new(ctx);
    if (!ssl) {
        perror("Error creating SSL");
        _isReady = false;
    }
    
    socketDescriptor = SSL_get_fd(ssl);
    SSL_set_fd(ssl, descriptor);
    int err = SSL_connect(ssl);
    if (err <= 0) {
        _isReady = false;
        printf("Error creating SSL connection. Error = %x\n", err);
    } else {
        printf("Client succesfully connected\n");
        handler = new BSDSocketHandler(ssl, descriptor, delegate, NULL);
    }
}


BSDClientSocket::~BSDClientSocket() {
    this->stopSocket();
}
