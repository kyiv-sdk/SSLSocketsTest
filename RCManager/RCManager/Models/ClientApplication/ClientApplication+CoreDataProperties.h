//
//  ClientApplication+CoreDataProperties.h
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/4/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//
//

#import "ClientApplication+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ClientApplication (CoreDataProperties)

+ (NSFetchRequest<ClientApplication *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSDate *lastConnection;
@property (nullable, nonatomic, copy) NSString *deviceID;
@property (nullable, nonatomic, copy) NSString *bundleID;
@property (nullable, nonatomic, retain) NSSet<ClientAction *> *acions;

@end

@interface ClientApplication (CoreDataGeneratedAccessors)

- (void)addAcionsObject:(ClientAction *)value;
- (void)removeAcionsObject:(ClientAction *)value;
- (void)addAcions:(NSSet<ClientAction *> *)values;
- (void)removeAcions:(NSSet<ClientAction *> *)values;

@end

NS_ASSUME_NONNULL_END
