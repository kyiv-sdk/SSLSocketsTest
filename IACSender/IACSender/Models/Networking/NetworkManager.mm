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



- (void)getTitleOfWebSiteWithURL:(NSURL *)url completionHandler:(void (^)(NSString * _Nullable))handler {
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSString *html = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            if (html) {
                NSArray *components1 = [html componentsSeparatedByString:@"<title>"];
                if (components1.count > 1) {
                    NSString *partWithTitle = components1[1];
                    NSArray *components2 = [partWithTitle componentsSeparatedByString:@"</title>"];
                    NSString *title = [components2 objectAtIndex:0];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        handler(title);
                    });
                }
            }
        } else if (error) {
            NSLog(@"getTitleOfWebSiteWithURL error: %@", [error localizedDescription]);
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(nil);
            });
        }
    }] resume];
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
