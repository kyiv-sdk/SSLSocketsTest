//
//  SendViewController.h
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/8/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestButton.h"
#import <SSLSockets/SSLSockets.h>
#import "SocketConnectionDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface SendViewController : UIViewController <SocketConnectionDelegate>

@property (weak, nonatomic) IBOutlet UILabel *connectionStatusLabel;
@property (weak, nonatomic) IBOutlet UITextField *URLToSendTextField;

@property (strong, nonatomic, nullable) SSLClientSocket *socket;
@property (assign, nonatomic) BOOL isAsking;

- (IBAction)sendURLButtonPressed:(TestButton *)sender;
- (IBAction)askForConnectionButtonPressed:(UIButton *)sender;
- (IBAction)disconnectButtonPressed:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
