//
//  RemoteServerLogger.h
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/31/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <SSLSockets/SSLSockets.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RemoteServerLogger : NSObject <SSLLoggable>

@property (assign, nonatomic) SSLLoggingPriority minPriority;

- (void)logMessage:(NSString *)message withPriority:(SSLLoggingPriority)priority;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
