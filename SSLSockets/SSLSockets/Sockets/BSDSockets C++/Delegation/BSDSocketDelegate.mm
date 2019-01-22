//
//  BSDSocketDelegate.cpp
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/15/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#include "SSLSocketDelegate.h"
#include "BSDSocketDelegate.h"

void BSDSocketDelegate::didReceiveMessage(std::string message, SSL *ssl) {
    const char *msg = message.c_str();
    NSStringEncoding encoding = [NSString defaultCStringEncoding];
    NSString *receivedMessage = [NSString stringWithCString:msg encoding:encoding];
    [(__bridge SSLSocketDelegate *)objcDelegate didReceiveMessage: receivedMessage fromSSL:ssl];
}


BSDSocketDelegate::BSDSocketDelegate(void *objcDelegate) {
    this->objcDelegate = objcDelegate;
}
