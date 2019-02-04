//
//  ProjectConstants.m
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/1/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "ProjectConstants.h"

#pragma mark - ProjectConstants
NSString * const kActiveApplicationCellName = @"ActiveApplicationCell";

#pragma mark - RCSocket
int RCServerSocketPort = 1666;
#pragma mark RCSocket Keys
NSString * const kRCActionKey = @"action";
NSString * const kRCAppNameKey = @"appName";
NSString * const kRCAppBundleID = @"appBundleId";
NSString * const kRCDeviceID = @"deviceId";
#pragma mark RCSocket Values
NSString * const kRCActionConnect = @"connect";
NSString * const kRCActionDisconnect = @"disconnect";
