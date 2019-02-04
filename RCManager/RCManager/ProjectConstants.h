//
//  ProjectConstants.h
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/1/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - ProjectConstants
extern NSString * const kActiveApplicationCellName;

#pragma mark - RCSocket
extern int RCServerSocketPort;
#pragma mark RCSocket Keys
extern NSString * const kRCActionKey;
extern NSString * const kRCAppNameKey;
extern NSString * const kRCAppBundleID;
extern NSString * const kRCDeviceID;
#pragma mark RCSocket Values
extern NSString * const kRCActionConnect;
extern NSString * const kRCActionDisconnect;
extern NSString * const kRCTerminateApplication;
