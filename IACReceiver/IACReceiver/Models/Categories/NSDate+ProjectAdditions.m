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
    NSString *fistPart =  [NSDate stringDate:self withFormat:@"MMM d, yyyy"];
    NSString *secondPart = [NSDate stringDate:self withFormat:@"HH:mm"];
    NSString *result = [NSString stringWithFormat:@"%@ at %@", fistPart, secondPart];
    return result;
}

@end
