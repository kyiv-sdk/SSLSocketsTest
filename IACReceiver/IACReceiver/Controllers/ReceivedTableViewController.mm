//
//  ReceivedTableViewController.m
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/8/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "ReceivedURLCell.h"
#import "CoreDataManager.h"
#import "WebSite+CoreDataProperties.h"
#import "ReceivedTableViewController.h"
#import "SSLSocketsManager.h"

@implementation ReceivedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webSites = [NSMutableArray arrayWithArray:[[CoreDataManager sharedManager] getWebSites]];
    [self updateWebSiteTitles];
}



- (int)openServerSocket {
    if ([self.socket isRunning]) return self.socket.port;
    
    int port;
    self.socketDelegate = [[URLSocketDelegate alloc] initWithWebSiteHandler:self];
    do {
        port = 1+ arc4random_uniform(65534);
        self.socket = [[SSLServerSocket alloc] initWithPort:port andDelegate:self.socketDelegate];
        [self.socket startSocket];
    } while (![self.socket isRunning]);
    return port;
}


- (void)updateWebSiteTitles {
    if (self.webSites) {
        for (WebSite *webSite in self.webSites) {
            if (!webSite.title) {
                [self updateTitleForWebSite:webSite];
            }
        }
    }
}


- (void)updateTitleForWebSite:(WebSite *)webSite {
    __block ReceivedTableViewController *weakSelf = self;
    [[CoreDataManager sharedManager] setTitleForWebSite:webSite comletionHandler:^{
        NSInteger idx = [self.webSites indexOfObject:webSite];
        if (idx != NSNotFound) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}



#pragma mark - <ReceivedWebSiteHandler>
- (void)didReceiveWebSite:(WebSite *)webSite {
    NSIndexPath *indexPath;
    
    if (self.webSites) {
        [self.webSites addObject:webSite];
        indexPath = [NSIndexPath indexPathForRow:[self.webSites count]-1 inSection:0];
    } else {
        self.webSites = [NSMutableArray arrayWithObject:webSite];
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self updateTitleForWebSite:webSite];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.webSites ? self.webSites.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReceivedURLCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceivedURLCell" forIndexPath:indexPath];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d, yyyy HH:mm"];
    
    WebSite *webSite = [self.webSites objectAtIndex:indexPath.row];
    [cell.receivedDate setText:[dateFormatter stringFromDate:webSite.date]];
    [cell.webPageNameLabel setText:webSite.title];
    [cell.webPageURLLabel setText:webSite.url];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WebSite *selectedWebSite = [self.webSites objectAtIndex:indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:selectedWebSite.url] options:@{} completionHandler:nil];
}


@end
