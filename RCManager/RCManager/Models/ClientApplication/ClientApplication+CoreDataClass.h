//
//  ClientApplication+CoreDataClass.h
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/4/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//
//

#import <SSLSockets/SSLSockets.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ClientAction;

NS_ASSUME_NONNULL_BEGIN

@interface ClientApplication : NSManagedObject

@property (unsafe_unretained, nonatomic) SSL *ssl;
@property (assign, nonatomic) CGSize screenSize;
@property (assign, nonatomic, readonly) CGFloat screenAspectRatio;

- (void)terminate;
- (void)wipeStorage;
- (void)shareScreenToPort:(int)port;
- (void)executeGesture:(NSArray *)gesture;
- (void)stopSharingScreen;

@end

NS_ASSUME_NONNULL_END

#import "ClientApplication+CoreDataProperties.h"
