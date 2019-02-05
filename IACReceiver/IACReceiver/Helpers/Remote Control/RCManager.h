//
//  RCManager.h
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/4/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCManager : NSObject

- (void)startSession;
- (void)stopSession;
- (void)shareScreenToPort:(int)port;
- (void)stopSharingScreen;


+ (instancetype) sharedInstance;

@end

NS_ASSUME_NONNULL_END
