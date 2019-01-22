//
//  BSDSocketHandler.cpp
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/15/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#include "unistd.h"
#include <sys/socket.h>
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
    return ssl;
}


bool BSDSocketHandler::isHandling() {
    return _isHandling;
}


void BSDSocketHandler::startHandling() {
    if (_isHandling) return;
    _isHandling = true;
    retainedThread = std::thread(&BSDSocketHandler::startReading, this);
}


void BSDSocketHandler::stopHandling() {
    if (!_isHandling) return;
    _isHandling = false;
    
    if (shutdown(descriptor, SHUT_RDWR) == FAIL_CODE) {
        perror("BSDSocketHandler shutdown error");
    }
    
    if (close(descriptor) == FAIL_CODE) {
        perror("BSDSocketHandler close error");
    }
    
    SSL_shutdown(ssl);
    SSL_free(ssl);
    if (retainedThread.joinable()) retainedThread.join();
    if (manager) manager->didStopHandler(this);
}


bool BSDSocketHandler::send(const char *data) {
    if (!_isHandling) return false;
    
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
        printf("SLL_write error #%d\n", SSL_get_error(ssl, len));
    }
    
    free(packet);
    free(size_buff);
    free(data_length_char);
    
    return true;
}



const std::vector<std::string> BSDSocketHandler::getReceivedInfo() {
    return receivedInfo;
}



void BSDSocketHandler::startReading() {
    while (_isHandling) {
        char buf[BufSize];
        int bytes = (int)SSL_read(ssl, &buf, BufSize);
        
        // Received Message
        if (bytes > 0) {
            if ((int)*buf == STXSymbolCode) {
                char *receivedData = readData();
                std::string receivedMessage(receivedData);
                receivedInfo.push_back(receivedMessage);
                if (delegate) delegate->didReceiveMessage(receivedMessage, ssl);
            }
        }
        
        // Error
        else if (bytes < 0) {
            printf("SLL_read error #%d\n", SSL_get_error(ssl, bytes));
        }
        
        // Disconnected
        else if (bytes == 0) {
            break;
        }
    }
}


char *BSDSocketHandler::readData() {
    char *data_buff;
    
    std::string buff_length;
    char buf[BufSize];
    SSL_read(ssl, &buf, BufSize);
    while ((int)*buf != EOTSymbolCode) {
        buff_length.append(CharSize, (char)(int)*buf);
        SSL_read(ssl, &buf, BufSize);
    }
    
    int data_length = getLength(buff_length);
    data_buff=(char *)malloc(data_length*sizeof(char));
    ssize_t byte_read = 0;
    ssize_t byte_offset = 0;
    
    while (byte_offset<data_length) {
        byte_read = SSL_read(ssl, data_buff+byte_offset, BufferSize);
        byte_offset+=byte_read;
        
        if(byte_read < BufferSize) {
            data_buff[byte_offset] = NullTerminalSymbol;
            byte_offset += CharSize;
        }
    }
    
    return data_buff;
}



BSDSocketHandler::BSDSocketHandler(SSL *ssl, int descriptor, BSDSocketDelegate *delegate, IBSDHandlersManager *manager) {
    this->ssl = ssl;
    this->manager = manager;
    this->delegate = delegate;
    this->descriptor = descriptor;
}


BSDSocketHandler::~BSDSocketHandler() {
    this->stopHandling();
}
