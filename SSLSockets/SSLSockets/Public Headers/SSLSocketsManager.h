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
     @brief Adds file as destination of logging and minimal priority of log to be logged.
     @param identifier - non-unique name of logger, which can be used for removing it from existing pool.
     @param name - name of file which will contains all of the SSLSockets logs with mentioned priority or higher.
     @param priority - minimal priority of log that will be logged.
 */
+ (void)addLoggingInFileWithName:(NSString *)name identifier:(NSString *)identifier andMinimalPriority:(SSLLoggingPriority)priority;

/**
     @brief Adds console as destination of logging and minimal priority of log to be logged.
     @param identifier - non-unique name of logger, which can be used for removing it from existing pool.
     @param priority - minimal priority of log that will be logged.
 */
+ (void)addLoggingInConsoleWithIdentifier:(NSString *)identifier andMinimalPriority:(SSLLoggingPriority)priority;

/**
     @brief Removes logger from loggers pool.
     @discussion As identifier is non-unique name, method will remove all loggers with passed identifier.
     @param identifier - non-unique name of logger, which should be removed from loggers pool.
 */
+ (void)removeLoggerWithIdentifier:(NSString *)identifier;

/**
    @brief Stops logging to given ILoggable *object. Method is required to be called when application going to be terminated.
 */
+ (void)stopLogging;

@end

NS_ASSUME_NONNULL_END
