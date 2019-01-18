//
//  SSLSigningManager.h
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/17/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#ifndef SSLSigningManager_h
#define SSLSigningManager_h

#include <thread>
#include "openssl/ssl.h"

class SSLSigningManager {
    
private:
    std::mutex mtxLibrary;
    bool isSSLLibraryInited;
    
    bool signContext(SSL_CTX *ctx);
    EVP_PKEY *generate_key();
    bool write_to_disk(EVP_PKEY *pkey, X509 *x509);
    X509 *generate_x509(EVP_PKEY *pkey,
                        const char *country,
                        const char *state,
                        const char *location,
                        const char *organization,
                        const char *organizationUnit,
                        const char *commonName,
                        const char *emailAddress);

    static std::mutex mtxCert;
    static std::mutex mtxSingletone;
    static bool isCertificateGenerated;
    static SSLSigningManager *_sharedInstance;

    
    SSLSigningManager();
    
public:
    void initSSLLibrary();
    SSL_CTX *generateContext();
    
    static SSLSigningManager *sharedInstance();
    static void configure(const char *country,
                          const char *state,
                          const char *location,
                          const char *organization,
                          const char *organizationUnit,
                          const char *commonName,
                          const char *emailAddress);
    
};

#endif /* SSLSigningManager_hpp */
