//
//  CoreDataManager.h
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/9/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "AppDelegate.h"
#import <Foundation/Foundation.h>
#import "WebSite+CoreDataProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataManager : NSObject

- (NSArray *)getWebSites;
- (WebSite *)addNewWebSiteWithURL:(NSString *)url;
- (void)setTitleForWebSite:(WebSite *)webSite comletionHandler:(void (^)(void))handler;

+ (instancetype)sharedManager;

@end

NS_ASSUME_NONNULL_END
