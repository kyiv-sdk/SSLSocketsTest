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
int RCServerSocketPort = 1666;
NSString * const RCServerSocketAddress = @"127.0.0.1";
#pragma mark RCSocket Keys
NSString * const kRCActionKey = @"action";
NSString * const kRCAppNameKey = @"appName";
NSString * const kRCAppBundleID = @"appBundleId";
NSString * const kRCDeviceID = @"deviceId";
#pragma mark RCSocket Values
NSString * const kRCActionConnect = @"connect";
NSString * const kRCActionDisconnect = @"disconnect";
NSString * const kRCTerminateApplication = @"terminate";
