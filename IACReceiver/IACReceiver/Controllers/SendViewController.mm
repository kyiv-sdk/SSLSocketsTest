//
//  SendViewController.m
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/8/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "NetworkManager.h"
#import "ProjectConstants.h"
#import "SendViewController.h"

@interface SendViewController ()

@end

@implementation SendViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)sendURLButtonPressed:(UIButton *)sender {
    if ([self.socket isRunning]) {
        // TODO: Check for url is valid
        NSDictionary<NSString *, id> *json = @{ @"url": [self.URLToSendTextField text] };
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
        NSString *msg = [[NSString alloc] initWithData:jsonData encoding: NSUTF8StringEncoding];
        [self.socket sendData:msg];
        [self.URLToSendTextField setText:@""];
    }
}

- (IBAction)askForConnectionButtonPressed:(UIButton *)sender {
    if (![self.socket isRunning] && !self.isAsking) {
        self.isAsking = true;
        [[NetworkManager sharedManager] askForSocketConnectionWithScheme:AnotherAppScheme
                                                                    host:OpenSocketRequest
                                                             andDelegate:self];

    }
}

- (IBAction)disconnectButtonPressed:(UIButton *)sender {
    [self.socket stopSocket];
    [self updateConnectionStatus];
    self.socket = nil;
}



- (void)updateConnectionStatus {
    if ([self.socket isRunning]) {
        [self.connectionStatusLabel setText:@"CONNECTED"];
        [self.connectionStatusLabel setTextColor:UIColor.greenColor];
    } else {
        [self.connectionStatusLabel setText:@"NOT CONNECTED"];
        [self.connectionStatusLabel setTextColor:UIColor.redColor];
    }
}



// MARK: - SocketConnectionDelegate
- (void)didOpenSocketWithPort:(int)port {
    self.socket = [[SSLClientSocket alloc] initWithPort:port];
    [self.socket startSocket];
    [self updateConnectionStatus];
}

@end
