//
//  RCSocketHandler.h
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/5/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <SSLSockets/SSLSockets.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RCSocketHandler <NSObject>

- (void)handleJSON:(NSDictionary *)json fromClient:(SSL *)client;

@end

NS_ASSUME_NONNULL_END
