//
//  ProjectConstants.h
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/17/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const MyAppScheme;
extern NSString * const AnotherAppScheme;

extern NSString * const OpenSocketRequest;
extern NSString * const OpenedSocketCallback;

extern NSString * const URLKey;

extern NSString * const SSLLoggerFileName;

#pragma mark - RCSocket
extern const int kRCScreenSharingDelay;
extern const double kScreenshotCompressionQuality;
extern const int RCServerSocketPort;
extern NSString * const RCServerSocketAddress;
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
