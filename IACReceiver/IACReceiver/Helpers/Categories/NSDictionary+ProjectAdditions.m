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

- (NSString *)convertedToString {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)RCConnectionJSON {
    NSMutableDictionary *json = [[NSMutableDictionary alloc] initWithDictionary:[NSDictionary applicationInfo]];
    [json setObject:kRCActionConnect forKey:kRCActionKey];
    return json;
}

+ (NSDictionary *)RCDisconnectionJSON {
    NSMutableDictionary *json = [[NSMutableDictionary alloc] initWithDictionary:[NSDictionary applicationInfo]];
    [json setObject:kRCActionDisconnect forKey:kRCActionKey];
    return json;
}

+ (NSDictionary *)RCSharingJSONWithScreenshot:(UIImage *)screenshot {
    NSString *imageString = [UIImageJPEGRepresentation(screenshot, kScreenshotCompressionQuality) base64EncodedStringWithOptions:0];
    return @{ kRCActionKey : kRCActionScreenSharing, kRCScreenshotKey : imageString };
}

+ (NSDictionary *)applicationInfo {
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    [info setObject:[NSString applicationName] forKey:kRCAppNameKey];
    [info setObject:[NSString applicationBundleId] forKey:kRCAppBundleID];
    [info setObject:[NSString deviceId] forKey:kRCDeviceID];
    return info;
}

@end
