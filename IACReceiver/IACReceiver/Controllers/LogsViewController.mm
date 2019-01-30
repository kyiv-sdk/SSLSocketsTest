//
//  LogsViewController.m
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 1/30/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "SSLUILogger.h"
#import "LogsViewController.h"

@interface LogsViewController ()

@end

@implementation LogsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SSLUILogger sharedInstance] setLogsContainer:self.logsContainer];
}


- (IBAction)clearLogsButtonPressed:(UIBarButtonItem *)sender {
    [[SSLUILogger sharedInstance] clearLogsHistory];
}

@end
