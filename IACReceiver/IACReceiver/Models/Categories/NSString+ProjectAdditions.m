//
//  NSString+ProjectAdditions.m
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 1/21/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "NSString+ProjectAdditions.h"

@implementation NSString (ProjectAdditions)

- (BOOL)isPotentialURL {
    NSString *urlRegEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlValidation = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlValidation evaluateWithObject:self];
}


- (NSString *)cleanTitle {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
