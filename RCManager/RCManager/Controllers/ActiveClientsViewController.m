//
//  ActiveClientsViewController.m
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/1/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "ProjectConstants.h"
#import "ActiveApplicationCell.h"
#import "ActiveClientsViewController.h"
#import "ClientApplication+CoreDataClass.h"

@implementation ActiveClientsViewController

#pragma mark - VC lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[RCApplicationStorage sharedInstance] setPresenter:self];
    
}

#pragma mark - Methods
- (void)prepareViewController {
    UINib *appNib = [UINib nibWithNibName:kActiveApplicationCellName bundle:nil];
    [self.tableView registerNib:appNib forCellReuseIdentifier:kActiveApplicationCellName];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[RCApplicationStorage sharedInstance] activeClientsCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActiveApplicationCell *cell = [tableView dequeueReusableCellWithIdentifier:kActiveApplicationCellName forIndexPath:indexPath];
    ClientApplication *application = [[RCApplicationStorage sharedInstance] applicationAtIndex:indexPath.row];
    [cell.applicationName setText:application.name];
    [cell.applicationBundleId setText:application.bundleID];
    [cell.applicationDeviceId setText:application.deviceID];
    return cell;
}

#pragma mark - <RCApplicationsPresenter>
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

#pragma mark - Destructor
- (void)dealloc {
    id presenter = [[RCApplicationStorage sharedInstance] presenter];
    if (presenter == self) {
        [[RCApplicationStorage sharedInstance] setPresenter:nil];
    }
}

@end
