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
#include "SSLLogger.h"
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



const SSL *BSDSocketHandler::getSSL() {
    SSLLogger::sharedInstance()->log(LOG, "BSDSocketHandler -> ssl asked.");
    return ssl;
}


bool BSDSocketHandler::isHandling() {
    return _isHandling;
}


void BSDSocketHandler::startHandling() {
    if (_isHandling) return;
    _isHandling = true;
    SSLLogger::sharedInstance()->log(LOG, "BSDSocketHandler -> started handling.");
    retainedThread = std::thread(&BSDSocketHandler::startReading, this);
}


void BSDSocketHandler::stopHandling() {
    if (!_isHandling) return;
    _isHandling = false;
    
    SSLLogger::sharedInstance()->log(LOG, "BSDSocketHandler -> will stop handling.");
    if (shutdown(descriptor, SHUT_RDWR) == FAIL_CODE) {
        SSLLogger::sharedInstance()->logERRNO("BSDSocketHandler -> shutdown failed");
    }
    
    if (close(descriptor) == FAIL_CODE) {
        SSLLogger::sharedInstance()->logERRNO("BSDSocketHandler -> close failed");
    }
    
    SSLLogger::sharedInstance()->log(LOG, "BSDSocketHandler -> freeing his ssl.");
    SSL_shutdown(ssl);
    SSL_free(ssl);
    SSLLogger::sharedInstance()->log(LOG, "BSDSocketHandler -> will join retained thread.");
    if (retainedThread.joinable()) retainedThread.join();
    SSLLogger::sharedInstance()->log(LOG, "BSDSocketHandler -> joined retained thread.");
    SSLLogger::sharedInstance()->log(LOG, "BSDSocketHandler -> will notify owner that it has stopped handling.");
    if (manager) manager->didStopHandler(this);
    SSLLogger::sharedInstance()->log(LOG, "BSDSocketHandler -> stopped handling.");
}


bool BSDSocketHandler::send(const char *data) {
    if (!_isHandling) {
        SSLLogger::sharedInstance()->log(ERROR, "BSDSocketHandler -> write failed because it's not handling.");
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
        SSLLogger::sharedInstance()->logSSLError("BSDSocketHandler -> write failed", errorCode);
    }
    
    free(packet);
    free(size_buff);
    free(data_length_char);
    
    SSLLogger::sharedInstance()->log(LOG, "BSDSocketHandler -> successfully sent message.");
    return true;
}



const std::vector<std::string> BSDSocketHandler::getReceivedInfo() {
    SSLLogger::sharedInstance()->log(LOG, "BSDSocketHandler -> receivedInfo asked.");
    return receivedInfo;
}



void BSDSocketHandler::startReading() {
    while (_isHandling) {
        char buf[BufSize];
        int bytes = (int)SSL_read(ssl, &buf, BufSize);
        
        if (bytes > 0) {
            SSLLogger::sharedInstance()->log(LOG, "BSDSocketHandler -> received message.");
            if ((int)*buf == STXSymbolCode) {
                SSLLogger::sharedInstance()->log(LOG, "BSDSocketHandler -> message has supported protocol, reading it.");
                char *receivedData = readData();
                std::string receivedMessage(receivedData);
                receivedInfo.push_back(receivedMessage);
                SSLLogger::sharedInstance()->log(LOG, "BSDSocketHandler -> redirecting received message to C++ delegate.");
                if (delegate) delegate->didReceiveMessage(receivedMessage, ssl);
            } else {
                SSLLogger::sharedInstance()->log(ERROR, "BSDSocketHandler -> message has unsupported protocol.");
            }
        }
        
        else if (bytes < 0) {
            int errorCode = SSL_get_error(ssl, bytes);
            SSLLogger::sharedInstance()->logSSLError("BSDSocketHandler -> read failed", errorCode);
        }
        
        else if (bytes == 0) {
            SSLLogger::sharedInstance()->log(LOG, "BSDSocketHandler -> Socket disconnected.");
            break;
        }
    }
}


char *BSDSocketHandler::readData() {
    char *data_buff;
    
    std::string buff_length;
    char buf[BufSize];
    SSL_read(ssl, &buf, BufSize);
    SSLLogger::sharedInstance()->log(LOG, "BSDSocketHandler -> reading message size.");
    while ((int)*buf != EOTSymbolCode) {
        buff_length.append(CharSize, (char)(int)*buf);
        SSL_read(ssl, &buf, BufSize);
    }
     SSLLogger::sharedInstance()->log(LOG, "BSDSocketHandler -> message size has been read.");
    
    int data_length = getLength(buff_length);
    data_buff=(char *)malloc(data_length*sizeof(char));
    ssize_t byte_read = 0;
    ssize_t byte_offset = 0;
    
    SSLLogger::sharedInstance()->log(LOG, "BSDSocketHandler -> reading message content.");
    while (byte_offset<data_length) {
        byte_read = SSL_read(ssl, data_buff+byte_offset, BufferSize);
        byte_offset+=byte_read;
        
        if(byte_read < BufferSize) {
            data_buff[byte_offset] = NullTerminalSymbol;
            byte_offset += CharSize;
        }
    }
    
    SSLLogger::sharedInstance()->log(LOG, "BSDSocketHandler -> message content has been successfully read.");
    return data_buff;
}



BSDSocketHandler::BSDSocketHandler(SSL *ssl, int descriptor, BSDSocketDelegate *delegate, IBSDHandlersManager *manager) {
    this->ssl = ssl;
    this->manager = manager;
    this->delegate = delegate;
    this->descriptor = descriptor;
    SSLLogger::sharedInstance()->log(LOG, "BSDSocketHandler -> instance created.");
}


BSDSocketHandler::~BSDSocketHandler() {
    this->stopHandling();
    SSLLogger::sharedInstance()->log(LOG, "BSDSocketHandler -> instance destructor called.");
}
