//
//  URLSocketDelegate.h
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/17/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <SSLSockets/SSLSockets.h>
#import <Foundation/Foundation.h>
#import "ReceivedWebSiteHandler.h"


NS_ASSUME_NONNULL_BEGIN

@interface URLSocketDelegate : NSObject <SSLSocketDelegate>

@property (weak, nonatomic) id <ReceivedWebSiteHandler> webSiteHandler;

- (instancetype)initWithWebSiteHandler:(id <ReceivedWebSiteHandler>)handler;

@end

NS_ASSUME_NONNULL_END
