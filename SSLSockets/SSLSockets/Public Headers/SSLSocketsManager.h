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
     @discussion As identifier is unique value, in case pool already contains logger with mentioned identifier, this one will replace it.
     @param identifier - unique name of logger, which can be used for removing it from existing pool.
     @param name - name of file which will contains all of the SSLSockets logs with mentioned priority or higher.
     @param priority - minimal priority of log that will be logged.
 */
+ (void)addLoggingInFileWithName:(NSString *)name identifier:(NSString *)identifier andMinimalPriority:(SSLLoggingPriority)priority;

/**
     @brief Adds console as destination of logging and minimal priority of log to be logged.
     @discussion As identifier is unique value, in case pool already contains logger with mentioned identifier, this one will replace it.
     @param identifier - unique name of logger, which can be used for removing it from existing pool.
     @param priority - minimal priority of log that will be logged.
 */
+ (void)addLoggingInConsoleWithIdentifier:(NSString *)identifier andMinimalPriority:(SSLLoggingPriority)priority;

/**
     @brief Removes logger from loggers pool.
     @param identifier - name of logger, which should be removed from loggers pool.
 */
+ (void)removeLoggerWithIdentifier:(NSString *)identifier;

/**
     @brief Removes loggers from loggers pool.
     @param identifier - class identifier of loggers, which should be removed from loggers pool.
 */
+ (void)removeLoggersWithClassIdentifier:(NSString *)identifier;

/**
    @brief Stops logging to given ILoggable *object. Method is required to be called when application going to be terminated.
 */
+ (void)stopLogging;

@end

NS_ASSUME_NONNULL_END
