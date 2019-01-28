//
//  SSLSocketsManager.m
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/17/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "SSLLogger.h"
#import "FileLogger.h"
#import "LoggingPriorities.h"
#import "SSLSocketsManager.h"
#import "SSLSigningManager.h"

@implementation SSLSocketsManager

+ (void)configureCertificatesWithCountry:(NSString *)country
                       state:(NSString *)state
                    location:(NSString *)location
                organization:(NSString *)organization
            organizationUnit:(NSString *)organizationUnit
                  commonName:(NSString *)commonName
                emailAddress:(NSString *)emailAddress {
    
    SSLSigningManager::configure([country UTF8String],
                                 [state UTF8String],
                                 [location UTF8String],
                                 [organization UTF8String],
                                 [organizationUnit UTF8String],
                                 [commonName UTF8String],
                                 [emailAddress UTF8String]);
}


+ (void)setLoggingInFileWithName:(NSString *)name andMinimalPriority:(SSLLoggingPriority)priority {
    std::string filename([name UTF8String]);
    LoggingPriority loggingPriority = LoggingPriority(priority);
    FileLogger *logger = new FileLogger(filename);
    SSLLogger::configureWith(logger, loggingPriority);
}

@end
