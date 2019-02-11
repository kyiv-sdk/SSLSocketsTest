//
//  ProjectConstants.m
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/17/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *MyAppScheme = @"iacreceiver";
NSString *AnotherAppScheme = @"iacsender";

NSString *OpenSocketRequest = @"opensocket";
NSString *OpenedSocketCallback = @"openedsocket";

NSString *URLKey = @"url";

NSString * SSLLoggerFileName = @"RSSLLoggerDestintion.txt";

#pragma mark - RCSocket
int kRCScreenSharingDelay = 1000000;
double kScreenshotCompressionQuality = 0.5;
int RCServerSocketPort = 1666;
NSString * const RCServerSocketAddress = @"10.131.203.54";
#pragma mark RCSocket Keys
NSString * const kRCActionKey = @"action";
NSString * const kRCAppNameKey = @"appName";
NSString * const kRCAppBundleID = @"appBundleId";
NSString * const kRCDeviceID = @"deviceId";
NSString * const kRCDeviceScreenWidth = @"deviceScreenWidth";
NSString * const kRCDeviceScreenHeight = @"deviceScreenHeight";
#pragma mark RCSocket Values
NSString * const kRCActionConnect = @"connect";
NSString * const kRCActionDisconnect = @"disconnect";
NSString * const kRCTerminateApplication = @"terminate";
NSString * const kRCWipeApplicationStorage = @"wipe";
#pragma mark RCSharing
NSString * const kRCActionStartScreenSharing = @"startScreenSharing";
NSString * const kRCActionStopScreenSharing = @"stopScreenSharing";
NSString * const kRCActionScreenSharing = @"screenSharing";
NSString * const kRCSharingPortKey = @"sharingPort";
NSString * const kRCScreenshotKey = @"screenshot";
NSString * const kRCGestureKey = @"gesture";
