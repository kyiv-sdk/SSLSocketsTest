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

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
