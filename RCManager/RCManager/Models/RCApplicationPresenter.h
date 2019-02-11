//
//  RCApplicationPresenter.h
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/5/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientApplication+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RCApplicationPresenter

- (void)setApplication:(ClientApplication *)application;
- (void)updateDisplayWithImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
