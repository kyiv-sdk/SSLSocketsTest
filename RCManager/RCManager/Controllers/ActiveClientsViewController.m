//
//  ActiveClientsViewController.m
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/1/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "ActiveClientsViewController.h"

@interface ActiveClientsViewController ()

@end

@implementation ActiveClientsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[RCApplicationStorage sharedInstance] setPresenter:self];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[RCApplicationStorage sharedInstance] activeClientsCount];
}

#pragma mark - RCApplicationStorage
- (void)didConnectApplication:(ClientApplication *)application {
    
}

- (void)dealloc {
    id presenter = [[RCApplicationStorage sharedInstance] presenter];
    if (presenter == self) {
        [[RCApplicationStorage sharedInstance] setPresenter:nil];
    }
}

- (void)updateApplicationsList {
    [self.tableView reloadData];
}

- (void)didConnectApplication:(ClientApplication *)application atIndex:(NSUInteger)index {
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didDisconnectApplication:(ClientApplication *)application atIndex:(NSUInteger)index {
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
