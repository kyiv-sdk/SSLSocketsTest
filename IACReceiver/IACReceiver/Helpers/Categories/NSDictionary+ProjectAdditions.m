//
//  NSDictionary+ProjectAdditions.m
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/4/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "ProjectConstants.h"
#import "NSString+ProjectAdditions.h"
#import "NSDictionary+ProjectAdditions.h"

@implementation NSDictionary (ProjectAdditions)

+ (NSDictionary *)RCConnectionJSON {
    NSMutableDictionary *json = [[NSMutableDictionary alloc] initWithDictionary:[NSDictionary applicationInfo]];
    [json setObject:kRCActionConnect forKey:kRCActionKey];
    return json;
}

+ (NSDictionary *)RCDisconnectionsJSON {
    NSMutableDictionary *json = [[NSMutableDictionary alloc] initWithDictionary:[NSDictionary applicationInfo]];
    [json setObject:kRCActionDisconnect forKey:kRCActionKey];
    return json;
}

+ (NSDictionary *)applicationInfo {
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    [info setObject:[NSString applicationName] forKey:kRCAppNameKey];
    [info setObject:[NSString applicationBundleId] forKey:kRCAppBundleID];
    [info setObject:[NSString deviceId] forKey:kRCDeviceID];
    return info;
}

@end
