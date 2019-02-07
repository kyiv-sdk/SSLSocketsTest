//
//  BSDServerSocket.cpp
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/15/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#include "unistd.h"
#include "sys/socket.h"
#include "netinet/in.h"
#include <openssl/err.h>
#include "Constants.h"
#include "CSSLLogger.h"
#include "BSDServerSocket.h"
#include "SSLSigningManager.h"

#pragma mark - Getters
const std::vector<BSDSocketHandler *> BSDServerSocket::getAcceptedSockets() {
    CSSLLogger::log(LOG, "BSDServerSocket -> accepted sockets asked.");
    return acceptedSockets;
}

#pragma mark - Methods
bool BSDServerSocket::startSocket() {
    if (_isRunning) {
        CSSLLogger::log(WARNING, "BSDServerSocket -> cannot start socket. It has already started.");
        return true;
    }
    if (sslContext) {
        _isRunning = true;
        CSSLLogger::log(LOG, "BSDServerSocket -> socket started.");
        retainedThread = std::thread(&BSDServerSocket::waitForConnections, this);
        return true;
    }
    CSSLLogger::log(ERROR, "BSDServerSocket -> cannot be started because sslContext == NULL.");
    _isReady = false;
    return false;
}

void BSDServerSocket::stopSocket() {
    if (!_isRunning) return;
    CSSLLogger::log(LOG, "BSDServerSocket -> stopSocket called.");
    _isRunning = false;
    if (sslContext && SSL_CTX_ct_is_enabled(sslContext)) {
        CSSLLogger::log(LOG, "BSDServerSocket -> freeing sslContext.");
        SSL_CTX_free(sslContext);
    }
    CSSLLogger::log(LOG, "BSDServerSocket -> socket wil close");
    if (close(socketDescriptor) == FAIL_CODE) {
        CSSLLogger::logERRNO("BSDServerSocket -> close failed");
    } else {
        CSSLLogger::log(LOG, "BSDServerSocket -> socket successfully closed");
    }
    CSSLLogger::log(LOG, "BSDServerSocket -> will delete accepted sockets pool.");
    long size = acceptedSockets.size();
    for (long i = size-1; i >= 0; i--) {
        BSDSocketHandler *handler = acceptedSockets.at(i);
        if (handler) delete handler;
    }
    CSSLLogger::log(LOG, "BSDServerSocket -> will join retained thread.");
    if (retainedThread.joinable()) retainedThread.join();
    CSSLLogger::log(LOG, "BSDServerSocket -> joined retained thread.");
}

bool BSDServerSocket::sendData(const char *data, SSL const *ssl) {
    CSSLLogger::log(LOG, "BSDServerSocket -> will find accepted socket to send message.");
    for (BSDSocketHandler *handler : acceptedSockets) {
        if (handler->getSSL() == ssl) {
            handler->send(data);
            CSSLLogger::log(LOG, "BSDServerSocket -> have found accepted socket to send message.");
            return true;
        }
    }
    CSSLLogger::log(ERROR, "BSDServerSocket -> haven't found accepted socket to send message.");
    return false;
}

void BSDServerSocket::waitForConnections() {
    _isRunning = true;
    while (_isRunning) {
        int acceptedSocket = accept(socketDescriptor, NULL, NULL);
        if (acceptedSocket >= 0) {
            CSSLLogger::log(LOG, "BSDServerSocket -> accepted new socket.");
            CSSLLogger::log(LOG, "BSDServerSocket -> creating SSL for new connection.");
            SSL *acceptedSSL = SSL_new(sslContext);
            CSSLLogger::log(LOG, "BSDServerSocket -> setting FD to created SSL.");
            SSL_set_fd(acceptedSSL, acceptedSocket);
            
            if (SSL_accept(acceptedSSL) <= 0) {
                unsigned long errorCode = ERR_get_error();
                CSSLLogger::logSSLError("BSDSocketHandler -> write failed", errorCode);
                
            } else {
                BSDSocketHandler *newSocketHandler = new BSDSocketHandler(acceptedSSL, acceptedSocket, delegate, this);
                acceptedSockets.push_back(newSocketHandler);
                CSSLLogger::log(LOG, "BSDServerSocket -> new SocketHandler pushed to accepted sockets pool.");
                newSocketHandler->startHandling();
            }
        } else {
            CSSLLogger::logERRNO("BSDServerSocket -> Cannont accept socket");
        }
    }
}

#pragma mark - IBSDHandlersManager confirming
void BSDServerSocket::didStopHandler(BSDSocketHandler *handler) {
    CSSLLogger::log(LOG, "BSDServerSocket -> received notification that accepted socket (sender) stopped handling.");
    ptrdiff_t idx = find(acceptedSockets.begin(), acceptedSockets.end(), handler) - acceptedSockets.begin();
    if (idx < acceptedSockets.size()) {
        CSSLLogger::log(LOG, "BSDServerSocket -> removed sender from its pool.");
        acceptedSockets.erase(acceptedSockets.begin() + idx);
    } else {
        CSSLLogger::log(ERROR, "BSDServerSocket -> haven't found sender in its pool.");
    }
}

#pragma mark - Constructors
BSDServerSocket::BSDServerSocket(int port) : BSDServerSocket(port, NULL) { }
BSDServerSocket::BSDServerSocket(int port, BSDSocketDelegate *delegate) : BSDSocket("127.0.0.1", port, delegate) {
    CSSLLogger::log(LOG, "BSDServerSocket -> constructor called.");
    bool flag = true;
    CSSLLogger::log(LOG, "BSDServerSocket -> will ask SSLSigningManager to generate context.");
    sslContext = SSLSigningManager::sharedInstance()->generateContext();

    CSSLLogger::log(LOG, "BSDServerSocket -> creating socket.");
    socketDescriptor = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (socketDescriptor == FAIL_CODE) {
        CSSLLogger::logERRNO("BSDServerSocket -> creation failed");
        flag = false;
    } else {
        CSSLLogger::log(LOG, "BSDServerSocket -> socket successfully created.");
    }
    
    struct sockaddr_in sock_addr;
    memset(&sock_addr, 0, sizeof(sock_addr));
    sock_addr.sin_len = sizeof(sock_addr);
    sock_addr.sin_family = PF_INET;
    sock_addr.sin_port = htons(port);
    sock_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    
    CSSLLogger::log(LOG, "BSDServerSocket -> binding socket with given port.");
    if (bind(socketDescriptor, (struct sockaddr *)&sock_addr, sizeof(sock_addr)) == FAIL_CODE) {
        CSSLLogger::logERRNO("BSDServerSocket -> Bind failed");
        flag = false;
    } else {
        CSSLLogger::log(LOG, "BSDServerSocket -> successfully binded with given port.");
    }
    
    CSSLLogger::log(LOG, "BSDServerSocket -> startning listening.");
    if (listen(socketDescriptor, 10) == FAIL_CODE) {
        CSSLLogger::logERRNO("BSDServerSocket -> Listen failed");
        flag = false;
    } else {
        CSSLLogger::log(LOG, "BSDServerSocket -> listening successfully started.");
    }
    
    if (!flag) {
        close(socketDescriptor);
        _isReady = false;
        CSSLLogger::log(LOG, "BSDServerSocket -> instance creation failed.");
    } else {
        CSSLLogger::log(LOG, "BSDServerSocket -> instance successfully created.");
    }
}

#pragma mark - Destructor
BSDServerSocket::~BSDServerSocket() {
    this->stopSocket();
    if (delegate) delete delegate;
}
