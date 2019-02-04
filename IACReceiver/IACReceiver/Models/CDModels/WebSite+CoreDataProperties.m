//
//  WebSite+CoreDataProperties.m
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/17/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//
//

#import "WebSite+CoreDataProperties.h"

@implementation WebSite (CoreDataProperties)

+ (NSFetchRequest<WebSite *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"WebSite"];
}

@dynamic title;
@dynamic url;
@dynamic date;

@end
