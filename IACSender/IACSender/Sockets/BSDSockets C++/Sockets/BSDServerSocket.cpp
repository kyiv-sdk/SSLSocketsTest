//
//  BSDServerSocket.cpp
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/15/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#include <iostream>
#include <fstream>
#include "unistd.h"
#include "sys/socket.h"
#include "netinet/in.h"
#include <openssl/err.h>
#include "Constants.h"
#include "BSDServerSocket.h"
#include "SSLSigningManager.h"

bool BSDServerSocket::startSocket() {
    if (_isRunning) return true;
    
    if (sslContext) {
        _isRunning = true;
        retainedThread = std::thread(&BSDServerSocket::waitForConnections, this);
        return true;
    }
    
    _isReady = false;
    return false;
}


void BSDServerSocket::stopSocket() {
    _isRunning = false;
    if (sslContext && SSL_CTX_ct_is_enabled(sslContext)) {
        SSL_CTX_free(sslContext);
    }
    
    if (close(socketDescriptor) == FAIL_CODE) {
        perror("BSDServerSocket close error");
    }
    
    for (BSDSocketHandler *handler : acceptedSockets) {
        delete handler;
    }
    
    if (retainedThread.joinable()) retainedThread.join();
}


bool BSDServerSocket::sendData(const char *data, SSL const *ssl) {
    for (BSDSocketHandler *handler : acceptedSockets) {
        if (handler->getSSL() == ssl) {
            handler->send(data);
            return true;
        }
    }
    return false;
}


const std::vector<std::string> BSDServerSocket::getReceivedInfo() {
    std::vector<std::string> info;
    for (BSDSocketHandler *handler : acceptedSockets) {
        const std::vector<std::string> handlerInfo = handler->getReceivedInfo();
        for (std::string message : handlerInfo) {
            info.push_back(message);
        }
    }
    return info;
}


const std::vector<BSDSocketHandler *> BSDServerSocket::getAcceptedSockets() {
    return acceptedSockets;
}


void BSDServerSocket::waitForConnections() {
    _isRunning = true;
    while (_isRunning) {
        int acceptedSocket = accept(socketDescriptor, NULL, NULL);
        if (acceptedSocket >= 0) {
            SSL *acceptedSSL = SSL_new(sslContext);
            SSL_set_fd(acceptedSSL, acceptedSocket);
            
            if (SSL_accept(acceptedSSL) <= 0) {
                ERR_print_errors_fp(stderr);
            } else {
                BSDSocketHandler *newSocketHandler = new BSDSocketHandler(acceptedSSL, acceptedSocket, delegate, this);
                acceptedSockets.push_back(newSocketHandler);
                newSocketHandler->startHandling();
            }
        } else {
            perror("Cannont accept socket");
        }
    }
}



void BSDServerSocket::didStopHandler(BSDSocketHandler *handler) {
    ptrdiff_t idx = find(acceptedSockets.begin(), acceptedSockets.end(), handler) - acceptedSockets.begin();
    if (idx < acceptedSockets.size()) {
        acceptedSockets.erase(acceptedSockets.begin() + idx);
    } else {
        printf("Handler not found\n");
    }
}


BSDServerSocket::BSDServerSocket(int port) : BSDServerSocket(port, NULL) { }
BSDServerSocket::BSDServerSocket(int port, BSDSocketDelegate *delegate) : BSDSocket("127.0.0.1", port, delegate) {
    bool flag = true;
    sslContext = SSLSigningManager::sharedInstance()->generateContext();

    socketDescriptor = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (socketDescriptor == FAIL_CODE) {
        perror("Socket create failed");
        flag = false;
    }
    
    struct sockaddr_in sock_addr;
    memset(&sock_addr, 0, sizeof(sock_addr));
    sock_addr.sin_len = sizeof(sock_addr);
    sock_addr.sin_family = PF_INET;
    sock_addr.sin_port = htons(port);
    sock_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    
    if (bind(socketDescriptor, (struct sockaddr *)&sock_addr, sizeof(sock_addr)) == FAIL_CODE) {
        perror("Bind failed");
        flag = false;
    }
    
    if (listen(socketDescriptor, 10) == FAIL_CODE) {
        perror("Listen failed");
        flag = false;
    }
    
    if (!flag) {
        close(socketDescriptor);
        _isReady = false;
    }
}


BSDServerSocket::~BSDServerSocket() {
    this->stopSocket();
}
