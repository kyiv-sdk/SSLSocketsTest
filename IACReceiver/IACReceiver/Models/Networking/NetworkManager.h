//
//  NetworkManager.h
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/9/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "AppDelegate.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject

- (void)shareSocketConnectionWithPort:(int)port toScheme:(NSString *)scheme withHost:(NSString *)host;
- (void)askForSocketConnectionWithScheme:(NSString *)scheme host:(NSString *)host andDelegate:(_Nullable id <SocketConnectionDelegate>)delegate;

+ (instancetype)sharedManager;

@end

NS_ASSUME_NONNULL_END
