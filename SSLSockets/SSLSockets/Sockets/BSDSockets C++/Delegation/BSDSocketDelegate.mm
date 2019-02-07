//
//  BSDSocketDelegate.cpp
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/15/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#include "CSSLLogger.h"
#include "SSLSocketDelegate.h"
#include "BSDSocketDelegate.h"

#pragma mark - Methods
void BSDSocketDelegate::didReceiveMessage(char *message, SSL *ssl) {
    NSStringEncoding encoding = [NSString defaultCStringEncoding];
    NSString *receivedMessage = [NSString stringWithCString:message encoding:encoding];
    CSSLLogger::log(LOG, "BSDSocketDelegate -> received message, redirected to Objective-C Delegate.");
    [(__bridge id <SSLSocketDelegate>)(objcDelegate) didReceiveMessage:receivedMessage fromSSL:ssl];
}

#pragma mark - Constructor
BSDSocketDelegate::BSDSocketDelegate(void *objcDelegate) {
    this->objcDelegate = objcDelegate;
    CSSLLogger::log(LOG, "BSDSocketDelegate -> instance created.");
}

#pragma mark - Destructor
BSDSocketDelegate::~BSDSocketDelegate() {
    CSSLLogger::log(LOG, "BSDSocketDelegate -> destructor called.");
    CFBridgingRelease(objcDelegate);
    CSSLLogger::log(LOG, "BSDSocketDelegate -> destroyed.");
}
