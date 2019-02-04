//
//  ReceivedTableViewController.h
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/8/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSLSockets/SSLSockets.h>
#import "URLSocketDelegate.h"
#import "ReceivedWebSiteHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReceivedTableViewController : UITableViewController <ReceivedWebSiteHandler>

@property (strong, nonatomic) NSMutableArray *webSites;
@property (strong, nonatomic) SSLServerSocket *socket;

- (int)openServerSocket;
- (void)didReceiveWebSite:(WebSite *)webSite;

@end

NS_ASSUME_NONNULL_END
