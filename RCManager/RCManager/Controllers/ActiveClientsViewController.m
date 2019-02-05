//
//  ActiveClientsViewController.m
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/1/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "ProjectConstants.h"
#import "ActiveApplicationCell.h"
#import "RCApplicationPresenter.h"
#import "RemoteControlController.h"
#import "ActiveClientsViewController.h"
#import "ClientApplication+CoreDataClass.h"

@interface ActiveClientsViewController ()

@property (strong, nonatomic) ClientApplication *selectedApplication;

@end



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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kRemoteControlControllerSegueIdentifier]) {
        id<RCApplicationPresenter> controller = segue.destinationViewController;
        [controller setApplication:self.selectedApplication];
        self.selectedApplication = nil;
    }
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

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedApplication = [[RCApplicationStorage sharedInstance] applicationAtIndex:indexPath.row];
    [self performSegueWithIdentifier:kRemoteControlControllerSegueIdentifier sender:self];
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

@end
