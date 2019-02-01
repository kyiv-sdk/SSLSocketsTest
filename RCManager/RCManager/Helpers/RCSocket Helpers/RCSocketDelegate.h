//
//  RCSocketDelegate.h
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/1/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <SSLSockets/SSLSockets.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCSocketDelegate : SSLSocketDelegate

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
