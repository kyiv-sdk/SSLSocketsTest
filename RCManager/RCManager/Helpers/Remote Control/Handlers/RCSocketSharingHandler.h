//
//  RCSocketSharingHandler.h
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/5/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "RCSocketHandler.h"
#import "RCApplicationPresenter.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCSocketSharingHandler : NSObject <RCSocketHandler>

- (instancetype)initWithPresenter:(id <RCApplicationPresenter>)presenter;

@end

NS_ASSUME_NONNULL_END
