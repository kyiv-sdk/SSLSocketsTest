//
//  ClientAction+CoreDataProperties.h
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/1/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//
//

#import "ClientAction+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ClientAction (CoreDataProperties)

+ (NSFetchRequest<ClientAction *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) ClientApplication *application;

@end

NS_ASSUME_NONNULL_END
