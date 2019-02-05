//
//  NSDictionary+ProjectAdditions.m
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/4/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "NSDictionary+ProjectAdditions.h"
#import "ProjectConstants.h"

@implementation NSDictionary (ProjectAdditions)

- (NSString *)convertedToString {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)RCWipingJSON {
    return @{ kRCActionKey : kRCWipeApplicationStorage };
}

+ (NSDictionary *)RCTerminationJSON {
    return @{ kRCActionKey : kRCTerminateApplication };
}

+ (NSDictionary *)RCSharingJSONWithPort:(int)port {
    return @{ kRCActionKey : kRCActionScreenSharing, kRCSharingPortKey : [NSNumber numberWithInt:port] };
}

+ (NSDictionary *)RCStopSharingJSONWithPort {
    return @{ kRCActionKey : kRCActionStopScreenSharing };
}

@end
