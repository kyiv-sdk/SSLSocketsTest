//
//  NSString+ProjectAdditions.m
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 1/21/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "NSString+ProjectAdditions.h"

@implementation NSString (ProjectAdditions)

- (NSString *)cleanTitle {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
