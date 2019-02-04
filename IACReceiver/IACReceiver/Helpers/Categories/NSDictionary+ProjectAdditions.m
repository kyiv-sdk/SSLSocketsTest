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
    NSDictionary *json = [[NSDictionary alloc] initWithDictionary:[NSDictionary applicationInfo]];
    [json setValue:kRCActionConnect forKey:kRCActionKey];
    return json;
}

+ (NSDictionary *)RCDisconnectionsJSON {
    NSDictionary *json = [[NSDictionary alloc] initWithDictionary:[NSDictionary applicationInfo]];
    [json setValue:kRCActionDisconnect forKey:kRCActionKey];
    return json;
}

+ (NSDictionary *)applicationInfo {
    NSDictionary *info = [[NSDictionary alloc] init];
    [info setValue:[NSString applicationName] forKey:kRCAppNameKey];
    [info setValue:[NSString applicationBundleId] forKey:kRCAppBundleID];
    [info setValue:[NSString deviceId] forKey:kRCDeviceID];
    return info;
}

@end
