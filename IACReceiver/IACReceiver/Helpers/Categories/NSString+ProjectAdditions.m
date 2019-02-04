//
//  NSString+ProjectAdditions.m
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 1/21/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+ProjectAdditions.h"
#import "NSDictionary+ProjectAdditions.h"

@implementation NSString (ProjectAdditions)

#pragma mark - Methods
- (BOOL)isPotentialURL {
    NSString *urlRegEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlValidation = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlValidation evaluateWithObject:self];
}

- (NSString *)cleanTitle {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - Static Methods
+ (NSString *)applicationName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+ (NSString *)applicationBundleId {
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)deviceId {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

@end
