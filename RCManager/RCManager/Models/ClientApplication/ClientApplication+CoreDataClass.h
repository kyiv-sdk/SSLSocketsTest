//
//  ClientApplication+CoreDataClass.h
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/1/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//
//

#import <SSLSockets/SSLSockets.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ClientAction;

NS_ASSUME_NONNULL_BEGIN

@interface ClientApplication : NSManagedObject

@property (unsafe_unretained, nonatomic, readonly) SSL const *ssl;

@end

NS_ASSUME_NONNULL_END

#import "ClientApplication+CoreDataProperties.h"
