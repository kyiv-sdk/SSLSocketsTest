//
//  RCSocketSharingHandler.h
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/5/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "RCSocketHandler.h"
#import "RCSharingPresenter.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCSocketSharingHandler : NSObject <RCSocketHandler>

- (instancetype)initWithPresenter:(id <RCSharingPresenter>)presenter;

@end

NS_ASSUME_NONNULL_END
