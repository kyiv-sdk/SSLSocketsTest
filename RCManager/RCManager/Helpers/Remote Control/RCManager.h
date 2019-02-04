//
//  RCManager.h
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/4/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SSLSockets/SSLSockets.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCManager : NSObject

- (void)startSession;
- (void)stopSession;
- (void)sendAction:(NSString *)action toClient:(SSL *)ssl;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
