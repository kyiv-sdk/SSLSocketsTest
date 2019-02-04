//
//  CoreDataManager.h
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/1/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientApplication+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataManager : NSObject

- (void)updateLastConnectionForApplication:(ClientApplication *)application;
- (void)getApplicationWithInfo:(NSDictionary *)info completion:(void (^)(ClientApplication *application))handler;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
