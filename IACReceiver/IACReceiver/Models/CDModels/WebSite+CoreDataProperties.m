//
//  WebSite+CoreDataProperties.m
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/5/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//
//

#import "WebSite+CoreDataProperties.h"

@implementation WebSite (CoreDataProperties)

+ (NSFetchRequest<WebSite *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"WebSite"];
}

@dynamic date;
@dynamic title;
@dynamic url;

@end
