//
//  NetworkManager.m
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/9/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager ()

@property (weak, nonatomic, readonly) UIApplication *application;
@property (weak, nonatomic, readonly) AppDelegate *appDelegate;

@end

@implementation NetworkManager

- (UIApplication *)application {
    return [UIApplication sharedApplication];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[self.application delegate];
}



- (void)shareSocketConnectionWithPort:(int)port toScheme:(NSString *)scheme withHost:(NSString *)host {
    NSURLComponents *cmp = [[NSURLComponents alloc] init];
    [cmp setScheme:scheme];
    [cmp setHost:host];
    [cmp setPort:[NSNumber numberWithInt:port]];
    [self.application openURL:[cmp URL] options:@{} completionHandler:nil];
}


- (void)askForSocketConnectionWithScheme:(NSString *)scheme host:(NSString *)host andDelegate:(id <SocketConnectionDelegate>)delegate {
    [self.appDelegate setSocketConnectionDelegate:delegate];
    NSURLComponents *cmp = [[NSURLComponents alloc] init];
    [cmp setScheme:scheme];
    [cmp setHost:host];
    [self.application openURL:[cmp URL] options:@{} completionHandler:nil];
}



+ (instancetype)sharedManager {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NetworkManager alloc] init];
    });
    return sharedInstance;
}

@end
