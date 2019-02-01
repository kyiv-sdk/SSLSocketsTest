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

@property (assign, nonatomic, readonly) NSUInteger activeClientsCount;
@property (copy, nonatomic, readonly) NSSet<ClientApplication *> *applications;
@property (weak, nonatomic) id <RCApplicationsPresenter> presenter;

- (void)addClientApplication:(ClientApplication *)application;
- (nullable ClientApplication *)removeApplicationWithIdentifier:(NSString *)identifier;
- (nullable ClientApplication *)getApplicationWithIdentifier:(NSString *)identifier;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
