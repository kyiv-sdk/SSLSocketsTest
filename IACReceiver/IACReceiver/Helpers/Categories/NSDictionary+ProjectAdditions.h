//
//  NSDictionary+ProjectAdditions.h
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/4/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (ProjectAdditions)

+ (NSDictionary *)RCConnectionJSON;
+ (NSDictionary *)RCDisconnectionsJSON;

@end

NS_ASSUME_NONNULL_END
