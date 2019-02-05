//
//  CoreDataManager+Protected.h
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/5/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "CoreDataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataManager (Protected)

@property (copy, nonatomic, readonly) NSEntityDescription *wipableEntities;

- (void)wipeStorage;

@end

NS_ASSUME_NONNULL_END
