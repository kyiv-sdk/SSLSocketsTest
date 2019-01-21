//
//  NSDate+ProjectAdditions.m
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 1/21/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "NSDate+ProjectAdditions.h"

@implementation NSDate (ProjectAdditions)

+ (NSString *)stringDate:(NSDate *)date withFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}


- (NSString *)receivedURLFormat {
    return [NSDate stringDate:self withFormat:@"MMM d, yyyy at HH:mm"];
}

@end
