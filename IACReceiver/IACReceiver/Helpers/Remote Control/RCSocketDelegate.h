//
//  RCSocketDelegate.h
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/4/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSLSockets/SSLSockets.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCSocketDelegate : NSObject <SSLSocketDelegate>

- (void)didReceiveMessage:(NSString *)message fromSSL:(SSL *)ssl;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
