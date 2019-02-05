//
//  NSDictionary+ProjectAdditions.h
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/4/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (ProjectAdditions)

- (NSString *)convertedToString;

+ (NSDictionary *)RCWipingJSON;
+ (NSDictionary *)RCTerminationJSON;
+ (NSDictionary *)RCSharingJSONWithPort:(int)port;
+ (NSDictionary *)RCStopSharingJSONWithPort;

@end

NS_ASSUME_NONNULL_END
