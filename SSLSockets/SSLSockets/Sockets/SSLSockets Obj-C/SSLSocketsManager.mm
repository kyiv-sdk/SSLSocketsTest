//
//  SSLSocketsManager.m
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/17/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "SSLLogger.h"
#import "FileLogger.h"
#import "ConsoleLogger.h"
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


+ (void)addLoggingInFileWithName:(NSString *)name identifier:(nonnull NSString *)identifier andMinimalPriority:(SSLLoggingPriority)priority {
    LoggingPriority lpriority = LoggingPriority(priority);
    std::string lidentifier([identifier UTF8String]);
    std::string filename([name UTF8String]);
    FileLogger *logger = new FileLogger(lidentifier, lpriority, filename);
    SSLLogger::addLogger(logger);
    logger->startLogging();
}


+ (void)addLoggingInConsoleWithIdentifier:(NSString *)identifier andMinimalPriority:(SSLLoggingPriority)priority {
    LoggingPriority lpriority = LoggingPriority(priority);
    std::string lidentifier([identifier UTF8String]);
    ConsoleLogger *logger = new ConsoleLogger(lidentifier, lpriority);
    SSLLogger::addLogger(logger);
}


+ (void)removeLoggerWithIdentifier:(NSString *)identifier {
    std::string lidentifier([identifier UTF8String]);
    SSLLogger::removeLoggerWithIdentifier(lidentifier);
}

+ (void)stopLogging {
    SSLLogger::stopLogging();
}

@end
