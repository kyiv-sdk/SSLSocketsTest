//
//  ClientApplication+CoreDataProperties.m
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/1/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//
//

#import "ClientApplication+CoreDataProperties.h"

@implementation ClientApplication (CoreDataProperties)

+ (NSFetchRequest<ClientApplication *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ClientApplication"];
}

@dynamic identifier;
@dynamic lastConnection;
@dynamic acions;

@end
