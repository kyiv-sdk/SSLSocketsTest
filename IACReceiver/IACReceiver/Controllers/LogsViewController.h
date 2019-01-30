//
//  LogsViewController.h
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 1/30/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *logsContainer;

- (IBAction)clearLogsButtonPressed:(UIBarButtonItem *)sender;

@end

NS_ASSUME_NONNULL_END
