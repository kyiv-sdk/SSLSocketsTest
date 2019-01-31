//
//  SSLSigningManager.cpp
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/17/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#include <stdexcept>
#include <openssl/err.h>
#include "CSSLLogger.h"
#include "FileManagement.h"
#include "SSLSigningManager.h"
#include <Foundation/Foundation.h>

#pragma mark - Methods
bool SSLSigningManager::signContext(SSL_CTX *ctx) {
    CSSLLogger::log(LOG, "SSLSigningManager -> Signing generated SSL Context.");
    SSL_CTX_set_ecdh_auto(ctx, 1);
    const char *certPath = pathForFile("cert.pem");
    const char *keyPath = pathForFile("key.pem");
    if (SSL_CTX_use_certificate_file(ctx, certPath, SSL_FILETYPE_PEM) <= 0) {
        unsigned long errorCode = ERR_get_error();
        CSSLLogger::logSSLError("SSLSigningManager -> SSL_CTX_use_certificate_file failed", errorCode);
        return false;
    }
    if (SSL_CTX_use_PrivateKey_file(ctx, keyPath, SSL_FILETYPE_PEM) <= 0 ) {
        unsigned long errorCode = ERR_get_error();
        CSSLLogger::logSSLError("SSLSigningManager -> SSL_CTX_use_PrivateKey_file failed", errorCode);
        return false;
    }
    CSSLLogger::log(LOG, "SSLSigningManager -> SSL Context successfully signed.");
    return true;
}

EVP_PKEY *SSLSigningManager::generate_key() {
    CSSLLogger::log(LOG, "SSLSigningManager -> Generating EVP_KEY started.");
    CSSLLogger::log(LOG, "SSLSigningManager -> Allocating memory for EVP_PKEY structure.");
    EVP_PKEY *pkey = EVP_PKEY_new();
    if (!pkey) {
        CSSLLogger::log(ERROR, "SSLSigningManager -> Failed allocating memory for EVP_PKEY structure.");
        return NULL;
    }
    CSSLLogger::log(LOG, "SSLSigningManager -> Generating RSA key and assign it to pkey.");
    RSA *rsa = RSA_new();
    BIGNUM *bn = BN_new();
    BN_set_word(bn, RSA_F4);
    int keyResp = RSA_generate_key_ex(rsa, 2048, bn, NULL);
    if (keyResp != 1) {
        CSSLLogger::log(ERROR, "SSLSigningManager -> Failed generating RSA key and assign it to pkey.");
    }
    CSSLLogger::log(LOG, "SSLSigningManager -> Assigning RSA key to EVP_PKEY structure.");
    if (!EVP_PKEY_assign_RSA(pkey, rsa)) {
        CSSLLogger::log(ERROR, "SSLSigningManager -> Failed assigning RSA key to EVP_PKEY structure.");
        EVP_PKEY_free(pkey);
        return NULL;
    }
    CSSLLogger::log(LOG, "SSLSigningManager -> EVP_KEY successfully generated.");
    return pkey;
}

X509 *SSLSigningManager::generate_x509(EVP_PKEY *pkey,
                                       const char *country,
                                       const char *state,
                                       const char *location,
                                       const char *organization,
                                       const char *organizationUnit,
                                       const char *commonName,
                                       const char *emailAddress) {
    
    CSSLLogger::log(LOG, "SSLSigningManager -> Generating X509 certificate started.");
    CSSLLogger::log(LOG, "SSLSigningManager -> Allocating memory for X509 structure.");
    X509 *x509 = X509_new();
    if (!x509) {
        CSSLLogger::log(ERROR, "SSLSigningManager -> Failed allocating memory for X509 structure.");
        return NULL;
    }
    CSSLLogger::log(LOG, "SSLSigningManager -> Setting serial number for X509.");
    ASN1_INTEGER_set(X509_get_serialNumber(x509), 1);
    CSSLLogger::log(LOG, "SSLSigningManager -> Setting lifetime of X509.");
    X509_gmtime_adj(X509_get_notBefore(x509), 0);
    X509_gmtime_adj(X509_get_notAfter(x509), 31536000L);
    CSSLLogger::log(LOG, "SSLSigningManager -> Setting public key for X509.");
    X509_set_pubkey(x509, pkey);
    CSSLLogger::log(LOG, "SSLSigningManager -> Copying subject name of generated X509.");
    X509_NAME *name = X509_get_subject_name(x509);
    CSSLLogger::log(LOG, "SSLSigningManager -> Configuring subject name of generated X509 with given info.");
    X509_NAME_add_entry_by_txt(name, "C",  MBSTRING_ASC, (unsigned char *)country, -1, -1, 0);
    X509_NAME_add_entry_by_txt(name, "ST", MBSTRING_ASC, (unsigned char *)state, -1, -1, 0);
    X509_NAME_add_entry_by_txt(name, "L",  MBSTRING_ASC, (unsigned char *)location, -1, -1, 0);
    X509_NAME_add_entry_by_txt(name, "O",  MBSTRING_ASC, (unsigned char *)organization, -1, -1, 0);
    X509_NAME_add_entry_by_txt(name, "OU", MBSTRING_ASC, (unsigned char *)organizationUnit, -1, -1, 0);
    X509_NAME_add_entry_by_txt(name, "CN", MBSTRING_ASC, (unsigned char *)commonName, -1, -1, 0);
    X509_NAME_add_entry_by_txt(name, "emailAddress", MBSTRING_ASC, (unsigned char *)emailAddress, -1, -1, 0);
    CSSLLogger::log(LOG, "SSLSigningManager -> Setting configured subject name to X509.");
    X509_set_issuer_name(x509, name);
    CSSLLogger::log(LOG, "SSLSigningManager -> Signing generated X509 with public key.");
    if (!X509_sign(x509, pkey, EVP_sha1())) {
        CSSLLogger::log(ERROR, "SSLSigningManager -> Failed signing generated X509 with public key.");
        X509_free(x509);
        return NULL;
    }
    CSSLLogger::log(LOG, "SSLSigningManager -> X509 certificate successfully generated.");
    return x509;
}

bool SSLSigningManager::write_to_disk(EVP_PKEY *pkey, X509 *x509) {
    CSSLLogger::log(LOG, "SSLSigningManager -> Writing generated PEM files to device memory.");
    FILE * pkey_file = iosfopen("key.pem", "wb");
    if (!pkey_file) {
        CSSLLogger::log(ERROR, "SSLSigningManager -> Failed opening key.pem file for writing key.");
        return false;
    }
    CSSLLogger::log(LOG, "SSLSigningManager -> Writing generated key to device memory.");
    bool ret = PEM_write_PrivateKey(pkey_file, pkey, NULL, NULL, 0, NULL, NULL);
    fclose(pkey_file);
    if (!ret) {
        CSSLLogger::log(ERROR, "SSLSigningManager -> Failed writing key to key.pem file.");
        return false;
    }
    FILE * x509_file = iosfopen("cert.pem", "wb");
    if (!x509_file) {
        CSSLLogger::log(ERROR, "SSLSigningManager -> Failed opening cert.pem file for writing certificate info.");
        return false;
    }
    CSSLLogger::log(LOG, "SSLSigningManager -> Writing certificate info to device memory.");
    ret = PEM_write_X509(x509_file, x509);
    fclose(x509_file);
    if (!ret) {
        CSSLLogger::log(ERROR, "SSLSigningManager -> Failed writing certificate info to cert.pem file.");
        return false;
    }
    CSSLLogger::log(LOG, "SSLSigningManager -> Generated PEM files succesfully written to device memory.");
    return true;
}

void SSLSigningManager::initSSLLibrary() {
    mtxLibrary.lock();
    if (isSSLLibraryInited) {
        mtxLibrary.unlock();
        return;
    }
    CSSLLogger::log(LOG, "SSLSigningManager -> Will init SSL components.");
    SSL_library_init();
    SSLeay_add_ssl_algorithms();
    SSL_load_error_strings();
    CSSLLogger::log(LOG, "SSLSigningManager -> SSL components have successfully inited.");
    
    isSSLLibraryInited = true;
    mtxLibrary.unlock();
}

SSL_CTX * SSLSigningManager::generateContext() {
    SSLSigningManager::mtxCert.lock();
    if (!SSLSigningManager::isCertificateGenerated) {
        CSSLLogger::log(FATAL_ERROR, "SSLSigningManager -> FATAL_ERROR: generating context without configuring SSLSocketsManager.");
        throw std::invalid_argument("SSLSocketsManager is not configured. To use SSLServerSocket you should do that.");
    }
    SSLSigningManager::mtxCert.unlock();
    
    CSSLLogger::log(LOG, "SSLSigningManager -> Generating SSL Context for SSLServerSocket.");
    SSL_CTX *ctx = SSL_CTX_new(SSLv23_server_method());
    if (ctx && signContext(ctx)) {
        CSSLLogger::log(LOG, "SSLSigningManager -> SSL Context successfully generated and signed.");
        return ctx;
    } else {
        unsigned long errorCode = ERR_get_error();
        CSSLLogger::logSSLError("SSLSigningManager -> SSLContext generating/signing failed", errorCode);
        return NULL;
    }
}

#pragma mark - Static properties
std::mutex SSLSigningManager::mtxCert;
std::mutex SSLSigningManager::mtxSingletone;
bool SSLSigningManager::isCertificateGenerated = false;
SSLSigningManager *SSLSigningManager::_sharedInstance = NULL;

#pragma mark - Static methods
SSLSigningManager *SSLSigningManager::sharedInstance() {
    mtxSingletone.lock();
    if (_sharedInstance) {
        mtxSingletone.unlock();
        return _sharedInstance;
    }
    CSSLLogger::log(LOG, "SSLSigningManager -> Creating SSLSigningManager Singletone.");
    _sharedInstance = new SSLSigningManager();
    mtxSingletone.unlock();
    return _sharedInstance;
}

void SSLSigningManager::configure(const char *country,
                                  const char *state,
                                  const char *location,
                                  const char *organization,
                                  const char *organizationUnit,
                                  const char *commonName,
                                  const char *emailAddress) {
    
    if (isCertificateGenerated) return;
    mtxCert.lock();
    SSLSigningManager *singletone = SSLSigningManager::sharedInstance();
    CSSLLogger::log(LOG, "SSLSigningManager -> Configuring SSLSigningManager for using SSLServerSocket.");
    EVP_PKEY * pkey = singletone->generate_key();
    X509 *x509 = singletone->generate_x509(pkey, country, state, location, organization, organizationUnit, commonName, emailAddress);
    singletone->write_to_disk(pkey, x509);
    EVP_PKEY_free(pkey);
    X509_free(x509);
    isCertificateGenerated = true;
    CSSLLogger::log(LOG, "SSLSigningManager -> Successfully configured SSLSigningManager for using SSLServerSocket.");
    mtxCert.unlock();
}

#pragma mark - Constructor
SSLSigningManager::SSLSigningManager() {
    isSSLLibraryInited = false;
}
