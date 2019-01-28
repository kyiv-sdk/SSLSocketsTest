//
//  SSLSocketsManager.h
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/17/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SSLLoggingPriority) {
    SSLLoggingPriorityLog,
    SSLLoggingPriorityWarning,
    SSLLoggingPriorityError,
    SSLLoggingPriorityFatalError
};

@interface SSLSocketsManager : NSObject

/**
    @brief Creates certificates for SSLServerSocket's context signing with given info.
 */
+ (void)configureCertificatesWithCountry:(NSString *)country
                                  state:(NSString *)state
                               location:(NSString *)location
                           organization:(NSString *)organization
                       organizationUnit:(NSString *)organizationUnit
                             commonName:(NSString *)commonName
                           emailAddress:(NSString *)emailAddress;

/**
    @brief Sets file as destination of logging and minimal priority of log to be logged.
    @discussion By default logging configured to do on console wtih priority 'Log'. This function changes destination to passed file and priority.
    @param name - name of file which will contains all of the SSLSockets logs.
    @param priority - minimal priority of log that will be logged.
 */
+ (void)setLoggingInFileWithName:(NSString *)name andMinimalPriority:(SSLLoggingPriority)priority;

@end

NS_ASSUME_NONNULL_END
