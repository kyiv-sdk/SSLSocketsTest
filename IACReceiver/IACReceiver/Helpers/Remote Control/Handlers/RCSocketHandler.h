//
//  RCSocketHandler.h
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/5/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RCSocketHandler <NSObject>

- (void)handleJSON:(NSDictionary *)json;

@end

NS_ASSUME_NONNULL_END
