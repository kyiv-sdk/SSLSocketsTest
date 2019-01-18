//
//  ReceivedWebSiteHandler.h
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/17/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "WebSite+CoreDataClass.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ReceivedWebSiteHandler

- (void)didReceiveWebSite:(WebSite *)webSite;

@end

NS_ASSUME_NONNULL_END
