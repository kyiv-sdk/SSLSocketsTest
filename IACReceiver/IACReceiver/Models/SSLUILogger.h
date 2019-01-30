//
//  SSLUILogger.h
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 1/30/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <SSLSockets/SSLSockets.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSLUILogger : NSObject <SSLLoggable>

@property (assign, nonatomic) SSLLoggingPriority minPriority;
@property (weak, nonatomic) UITextView *logsContainer;

- (void)logMessage:(NSString *)message withPriority:(SSLLoggingPriority)priority;
- (void)clearLogsHistory;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
