//
//  BSDSocketHandler.cpp
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/15/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#include "unistd.h"
#include <sys/socket.h>
#include <openssl/err.h>
#include "CSSLLogger.h"
#include "Constants.h"
#include "BSDSocketHandler.h"

int getLength(std::string data) {
    std::string clearDataLength;
    for (int i = 0; i<data.length(); i++) {
        if (data[i] >= '0' && data[i] <= '9') {
            clearDataLength += data[i];
        }
    }
    return std::stoi(clearDataLength);
}


#pragma mark - Getters
const SSL *BSDSocketHandler::getSSL() {
    CSSLLogger::log(LOG, "BSDSocketHandler -> ssl asked.");
    return ssl;
}

bool BSDSocketHandler::isHandling() {
    return _isHandling;
}

#pragma mark - Mehods
void BSDSocketHandler::startHandling() {
    if (_isHandling) {
        CSSLLogger::log(WARNING, "BSDSocketHandler -> Cannot start becase it is already started.");
        return;
    }
    _isHandling = true;
    CSSLLogger::log(LOG, "BSDSocketHandler -> started handling.");
    retainedThread = std::thread(&BSDSocketHandler::startReading, this);
}

void BSDSocketHandler::stopHandling() {
    if (!_isHandling) return;
    _isHandling = false;
    CSSLLogger::log(LOG, "BSDSocketHandler -> will stop handling.");
    if (shutdown(descriptor, SHUT_RDWR) == FAIL_CODE) {
        CSSLLogger::logERRNO("BSDSocketHandler -> shutdown failed");
    }
    if (close(descriptor) == FAIL_CODE) {
        CSSLLogger::logERRNO("BSDSocketHandler -> close failed");
    }
    CSSLLogger::log(LOG, "BSDSocketHandler -> freeing his ssl.");
    SSL_shutdown(ssl);
    SSL_free(ssl);
    CSSLLogger::log(LOG, "BSDSocketHandler -> will join retained thread.");
    if (retainedThread.joinable()) retainedThread.join();
    CSSLLogger::log(LOG, "BSDSocketHandler -> joined retained thread.");
    CSSLLogger::log(LOG, "BSDSocketHandler -> will notify owner that it has stopped handling.");
    if (manager) manager->didStopHandler(this);
    CSSLLogger::log(LOG, "BSDSocketHandler -> stopped handling.");
}

bool BSDSocketHandler::send(const char *data) {
    if (!_isHandling) {
        CSSLLogger::log(ERROR, "BSDSocketHandler -> write failed because it's not handling.");
        return false;
    }
    int initialize[CharSize]; initialize[FirstElementIndex] = { STXSymbolCode };
    int separator[CharSize]; separator[FirstElementIndex] = { EOTSymbolCode };
    int data_length=(int)strlen(data);
    int target_length=snprintf(NULL, 0, "%d", data_length);
    char *data_length_char = (char *)malloc(target_length+CharSize);
    snprintf(data_length_char, target_length+CharSize, "%d", data_length);
    int ele_count=(int)strlen(data_length_char);
    int *size_buff=(int*)malloc(ele_count*sizeof(int));
    for (int counter = 0; counter < ele_count; counter++) {
        size_buff[counter]=(int)data_length_char[counter];
    }
    int packet_length = sizeof(STXSymbol) + ele_count + sizeof(EOTSymbol) + (int)strlen(data);
    uint8_t *packet=(uint8_t *)malloc(packet_length * sizeof(uint8_t));
    memcpy(&packet[FirstElementIndex], initialize, sizeof(STXSymbol));
    for (int counter = 0; counter < ele_count; counter++) {
        memcpy(&packet[counter + CharSize], &size_buff[counter], sizeof(EOTSymbol));
    }
    memcpy(&packet[sizeof(STXSymbol) + ele_count], separator, sizeof(EOTSymbol));
    memcpy(&packet[sizeof(STXSymbol) + ele_count + sizeof(EOTSymbol)], data, strlen(data));
    int len = (int)SSL_write(ssl, packet, packet_length);
    if (len <= 0 ) {
        int errorCode = SSL_get_error(ssl, len);
        CSSLLogger::logSSLError("BSDSocketHandler -> write failed", errorCode);
    }
    free(packet);
    free(size_buff);
    free(data_length_char);
    CSSLLogger::log(LOG, "BSDSocketHandler -> successfully sent message.");
    return true;
}

void BSDSocketHandler::startReading() {
    while (_isHandling) {
        char buf[BufSize];
        int bytes = (int)SSL_read(ssl, &buf, BufSize);
        if (bytes > 0) {
            CSSLLogger::log(LOG, "BSDSocketHandler -> received message.");
            if ((int)*buf == STXSymbolCode) {
                CSSLLogger::log(LOG, "BSDSocketHandler -> message has supported protocol, reading it.");
                char *receivedData = readData();
                CSSLLogger::log(LOG, "BSDSocketHandler -> redirecting received message to C++ delegate.");
                if (delegate) delegate->didReceiveMessage(receivedData, ssl);
                free(receivedData);
            } else {
                CSSLLogger::log(ERROR, "BSDSocketHandler -> message has unsupported protocol.");
            }
        }
        else if (bytes < 0) {
            int errorCode = SSL_get_error(ssl, bytes);
            CSSLLogger::logSSLError("BSDSocketHandler -> read failed", errorCode);
        }
        else if (bytes == 0) {
            CSSLLogger::log(LOG, "BSDSocketHandler -> Socket disconnected.");
            break;
        }
    }
}

char *BSDSocketHandler::readData() {
    char *data_buff;
    std::string buff_length;
    char buf[BufSize];
    SSL_read(ssl, &buf, BufSize);
    CSSLLogger::log(LOG, "BSDSocketHandler -> reading message size.");
    while ((int)*buf != EOTSymbolCode) {
        buff_length.append(CharSize, (char)(int)*buf);
        SSL_read(ssl, &buf, BufSize);
    }
    CSSLLogger::log(LOG, "BSDSocketHandler -> message size has been read.");
    int data_length = getLength(buff_length);
    data_buff=(char *)malloc(data_length*sizeof(char));
    ssize_t byte_read = 0;
    ssize_t byte_offset = 0;
    CSSLLogger::log(LOG, "BSDSocketHandler -> reading message content.");
    while (byte_offset<data_length) {
        byte_read = SSL_read(ssl, data_buff+byte_offset, BufferSize);
        byte_offset+=byte_read;
        if(byte_read < BufferSize && byte_offset >= data_length) {
            data_buff[byte_offset] = NullTerminalSymbol;
            byte_offset += CharSize;
        }
    }
    CSSLLogger::log(LOG, "BSDSocketHandler -> message content has been successfully read.");
    return data_buff;
}

#pragma mark - Constructor
BSDSocketHandler::BSDSocketHandler(SSL *ssl, int descriptor, BSDSocketDelegate *delegate, IBSDHandlersManager *manager) {
    _isHandling = false;
    this->ssl = ssl;
    this->manager = manager;
    this->delegate = delegate;
    this->descriptor = descriptor;
    CSSLLogger::log(LOG, "BSDSocketHandler -> instance created.");
}

#pragma mark - Destructor
BSDSocketHandler::~BSDSocketHandler() {
    this->stopHandling();
    CSSLLogger::log(LOG, "BSDSocketHandler -> instance destructor called.");
}
