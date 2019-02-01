//
//  RCApplicationsPresenter.h
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/1/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientApplication+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RCApplicationsPresenter <NSObject>

- (void)updateApplicationsList;
- (void)didConnectApplication:(ClientApplication *)application atIndex:(NSUInteger)index;
- (void)didDisconnectApplication:(ClientApplication *)application  atIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
