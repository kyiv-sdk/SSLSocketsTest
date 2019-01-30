//
//  SSLLoggable.h
//  SSLSockets
//
//  Created by Oleksandr Hordiienko on 1/30/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, SSLLoggingPriority) {
    SSLLoggingPriorityLog,
    SSLLoggingPriorityWarning,
    SSLLoggingPriorityError,
    SSLLoggingPriorityFatalError
};


NS_ASSUME_NONNULL_BEGIN

@protocol SSLLoggable <NSObject>

@property (assign, nonatomic) SSLLoggingPriority minPriority;

- (void)logMessage:(NSString *)message withPriority:(SSLLoggingPriority)priority;

@end

NS_ASSUME_NONNULL_END
