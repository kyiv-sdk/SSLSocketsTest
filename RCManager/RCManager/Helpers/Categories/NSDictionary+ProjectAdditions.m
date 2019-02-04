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

- (NSString *)convertToString {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)RCTerminationJSON {
    return @{ kRCActionKey : kRCTerminateApplication };
}

@end
