//
//  ClientAction+CoreDataProperties.m
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/1/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//
//

#import "ClientAction+CoreDataProperties.h"

@implementation ClientAction (CoreDataProperties)

+ (NSFetchRequest<ClientAction *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ClientAction"];
}

@dynamic date;
@dynamic name;
@dynamic application;

@end
