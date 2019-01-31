//
//  SSLUILogger.m
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 1/30/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "SSLUILogger.h"

@interface SSLUILogger ()

@property (strong, nonatomic) NSMutableArray *logsHistory;
@property (strong, nonatomic) dispatch_queue_t serialThread;

@end

@implementation SSLUILogger

- (void)setLogsContainer:(UITextView *)logsContainer {
    _logsContainer = logsContainer;
    [logsContainer setText:[self.logsHistory componentsJoinedByString:@"\n"]];
}

- (void)logMessage:(NSString *)message withPriority:(SSLLoggingPriority)priority {
    dispatch_async(self.serialThread, ^{
        [self.logsHistory addObject:message];
        [self updateLogsWithMessage:message];
    });
}

- (void)updateLogsWithMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *newLog = [@"\n" stringByAppendingString:message];
        NSString *newLogs = [self.logsContainer.text stringByAppendingString:newLog];
        [self.logsContainer setText:newLogs];
    });
}

- (void)clearLogsHistory {
    [self.logsHistory removeAllObjects];
    [self.logsContainer setText:@""];
}

#pragma mark Singletone
+ (instancetype)sharedInstance {
    static id _sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[SSLUILogger alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.minPriority = SSLLoggingPriorityLog;
        self.logsHistory = [[NSMutableArray alloc] init];
        self.serialThread = dispatch_queue_create("com.o9e6y.SSLUILogger", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

@end
