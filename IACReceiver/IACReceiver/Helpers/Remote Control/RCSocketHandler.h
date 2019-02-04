//
//  RCSocketHandler.h
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/4/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCSocketHandler : NSObject

- (void)handleJSON:(NSDictionary *)json;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
