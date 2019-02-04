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
extern int RCServerSocketPort;
extern NSString * const RCServerSocketAddress;
#pragma mark RCSocket Keys
extern NSString * const kRCActionKey;
extern NSString * const kRCAppNameKey;
extern NSString * const kRCAppBundleID;
extern NSString * const kRCDeviceID;
#pragma mark RCSocket Values
extern NSString * const kRCActionConnect;
extern NSString * const kRCActionDisconnect;
