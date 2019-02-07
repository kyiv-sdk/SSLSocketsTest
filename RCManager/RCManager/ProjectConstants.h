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
extern NSString * const kRemoteControlControllerSegueIdentifier;

#pragma mark - RCSocket
extern int RCServerSocketPort;
#pragma mark RCSocket Keys
extern NSString * const kRCActionKey;
extern NSString * const kRCAppNameKey;
extern NSString * const kRCAppBundleID;
extern NSString * const kRCDeviceID;
extern NSString * const kRCDeviceScreenWidth;
extern NSString * const kRCDeviceScreenHeight;
#pragma mark RCSocket Values
extern NSString * const kRCActionConnect;
extern NSString * const kRCActionDisconnect;
extern NSString * const kRCTerminateApplication;
extern NSString * const kRCWipeApplicationStorage;
#pragma mark RCSharing Keys
extern NSString * const kRCActionStartScreenSharing;
extern NSString * const kRCActionStopScreenSharing;
extern NSString * const kRCActionScreenSharing;
extern NSString * const kRCSharingPortKey;
extern NSString * const kRCScreenshotKey;
extern NSString * const kRCGestureKey;
