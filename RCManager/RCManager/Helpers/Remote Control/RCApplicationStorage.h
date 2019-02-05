//
//  RCApplicationStorage.h
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/1/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCApplicationsPresenter.h"
#import "ClientApplication+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCApplicationStorage : NSObject

@property (copy, nonatomic, readonly) NSArray<ClientApplication *> *applications;
@property (assign, nonatomic, readonly) NSUInteger activeClientsCount;
@property (weak, nonatomic) id <RCApplicationsPresenter> presenter;

- (void)addApplication:(ClientApplication *)application;
- (void)removeApplication:(ClientApplication *)application;
- (ClientApplication *)applicationAtIndex:(NSUInteger)index;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
