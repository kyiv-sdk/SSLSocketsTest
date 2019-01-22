//
//  SSLSigningManager.cpp
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/17/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#include <stdexcept>
#include <openssl/err.h>
#include "SSLSigningManager.h"
#include <Foundation/Foundation.h>

const char *pathForFile(const char *filename) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileString = [NSString stringWithCString:filename encoding:NSASCIIStringEncoding];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileString];
    return [path cStringUsingEncoding:NSASCIIStringEncoding];
}

FILE *iosfopen(const char *filename, const char *mode) {
    const char *filePath = pathForFile(filename);
    return fopen(filePath, mode);
}


bool SSLSigningManager::signContext(SSL_CTX *ctx) {
    SSL_CTX_set_ecdh_auto(ctx, 1);
    
    const char *certPath = pathForFile("cert.pem");
    const char *keyPath = pathForFile("key.pem");
    
    if (SSL_CTX_use_certificate_file(ctx, certPath, SSL_FILETYPE_PEM) <= 0) {
        ERR_print_errors_fp(stderr);
        return false;
    }
    
    if (SSL_CTX_use_PrivateKey_file(ctx, keyPath, SSL_FILETYPE_PEM) <= 0 ) {
        ERR_print_errors_fp(stderr);
        return false;
    }
    
    return true;
}


EVP_PKEY *SSLSigningManager::generate_key() {
    /* Allocate memory for the EVP_PKEY structure. */
    EVP_PKEY * pkey = EVP_PKEY_new();
    if (!pkey) {
        return NULL;
    }
    
    /* Generate the RSA key and assign it to pkey. */
    RSA *rsa = RSA_new();
    BIGNUM *bn = BN_new();
    BN_set_word(bn, RSA_F4);
    int keyResp = RSA_generate_key_ex(rsa, 2048, bn, NULL);
    if (keyResp != 1) {
        printf("RSA_generate_key_ex failed\n");
    }
    
    if (!EVP_PKEY_assign_RSA(pkey, rsa)) {
        EVP_PKEY_free(pkey);
        return NULL;
    }
    
    /* The key has been generated, return it. */
    return pkey;
}

/* Generates a self-signed x509 certificate. */
X509 *SSLSigningManager::generate_x509(EVP_PKEY *pkey,
                                       const char *country,
                                       const char *state,
                                       const char *location,
                                       const char *organization,
                                       const char *organizationUnit,
                                       const char *commonName,
                                       const char *emailAddress) {
    
    /* Allocate memory for the X509 structure. */
    X509 * x509 = X509_new();
    if (!x509) {
        return NULL;
    }
    
    /* Set the serial number. */
    ASN1_INTEGER_set(X509_get_serialNumber(x509), 1);
    
    /* This certificate is valid from now until exactly one year from now. */
    X509_gmtime_adj(X509_get_notBefore(x509), 0);
    X509_gmtime_adj(X509_get_notAfter(x509), 31536000L);
    
    /* Set the public key for our certificate. */
    X509_set_pubkey(x509, pkey);
    
    /* We want to copy the subject name to the issuer name. */
    X509_NAME * name = X509_get_subject_name(x509);
    
    /* Set the country code and common name. */
    X509_NAME_add_entry_by_txt(name, "C",  MBSTRING_ASC, (unsigned char *)country, -1, -1, 0);
    X509_NAME_add_entry_by_txt(name, "ST", MBSTRING_ASC, (unsigned char *)state, -1, -1, 0);
    X509_NAME_add_entry_by_txt(name, "L",  MBSTRING_ASC, (unsigned char *)location, -1, -1, 0);
    X509_NAME_add_entry_by_txt(name, "O",  MBSTRING_ASC, (unsigned char *)organization, -1, -1, 0);
    X509_NAME_add_entry_by_txt(name, "OU", MBSTRING_ASC, (unsigned char *)organizationUnit, -1, -1, 0);
    X509_NAME_add_entry_by_txt(name, "CN", MBSTRING_ASC, (unsigned char *)commonName, -1, -1, 0);
    X509_NAME_add_entry_by_txt(name, "emailAddress", MBSTRING_ASC, (unsigned char *)emailAddress, -1, -1, 0);
    
    /* Now set the issuer name. */
    X509_set_issuer_name(x509, name);
    
    /* Actually sign the certificate with our key. */
    if (!X509_sign(x509, pkey, EVP_sha1())) {
        printf("Error signing certificate.\n");
        X509_free(x509);
        return NULL;
    }
    
    return x509;
}


bool SSLSigningManager::write_to_disk(EVP_PKEY *pkey, X509 *x509) {
    /* Open the PEM file for writing the key to disk. */
    FILE * pkey_file = iosfopen("key.pem", "wb");
    if (!pkey_file) {
        printf("Unable to open \"key.pem\" for writing.\n");
        return false;
    }
    
    /* Write the key to disk. */
    bool ret = PEM_write_PrivateKey(pkey_file, pkey, NULL, NULL, 0, NULL, NULL);
    fclose(pkey_file);
    
    if (!ret) {
        printf("Unable to open \"key.pem\" for writing.\n");
        return false;
    }
    
    /* Open the PEM file for writing the certificate to disk. */
    FILE * x509_file = iosfopen("cert.pem", "wb");
    if (!x509_file) {
        printf("Unable to open \"cert.pem\" for writing.\n");
        return false;
    }
    
    /* Write the certificate to disk. */
    ret = PEM_write_X509(x509_file, x509);
    fclose(x509_file);
    
    if (!ret) {
        printf("Unable to open \"key.pem\" for writing.\n");
        return false;
    }
    
    return true;
}



SSLSigningManager::SSLSigningManager() {
    isSSLLibraryInited = false;
}



void SSLSigningManager::initSSLLibrary() {
    mtxLibrary.lock();
    if (isSSLLibraryInited) {
        mtxLibrary.unlock();
        return;
    }
    
    SSL_library_init();
    SSLeay_add_ssl_algorithms();
    SSL_load_error_strings();
    
    isSSLLibraryInited = true;
    mtxLibrary.unlock();
}


SSL_CTX * SSLSigningManager::generateContext() {
    SSLSigningManager::mtxCert.lock();
    if (!SSLSigningManager::isCertificateGenerated) {
        throw std::invalid_argument("SSLSocketsManager is not configured. To use SSLServerSocket you should do that.");
    }
    SSLSigningManager::mtxCert.unlock();
    
    SSL_CTX *ctx = SSL_CTX_new(SSLv23_server_method());
    if (ctx && signContext(ctx)) {
        return ctx;
    } else {
        ERR_print_errors_fp(stderr);
        return NULL;
    }
}


std::mutex SSLSigningManager::mtxSingletone;
SSLSigningManager *SSLSigningManager::_sharedInstance = NULL;
SSLSigningManager *SSLSigningManager::sharedInstance() {
    mtxSingletone.lock();
    if (_sharedInstance) {
        mtxSingletone.unlock();
        return _sharedInstance;
    }
    _sharedInstance = new SSLSigningManager();
    mtxSingletone.unlock();
    return _sharedInstance;
}


std::mutex SSLSigningManager::mtxCert;
bool SSLSigningManager::isCertificateGenerated = false;
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
    EVP_PKEY * pkey = singletone->generate_key();
    X509 *x509 = singletone->generate_x509(pkey, country, state, location, organization, organizationUnit, commonName, emailAddress);
    singletone->write_to_disk(pkey, x509);
    EVP_PKEY_free(pkey);
    X509_free(x509);
    isCertificateGenerated = true;
    
    mtxCert.unlock();
}
