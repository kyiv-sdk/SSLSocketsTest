//
//  NSDictionary+ProjectAdditions.h
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/4/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (ProjectAdditions)

- (NSString *)convertedToString;
+ (NSDictionary *)RCConnectionJSON;
+ (NSDictionary *)RCDisconnectionJSON;
+ (NSDictionary *)RCSharingJSONWithScreenshot:(UIImage *)screenshot;

@end

NS_ASSUME_NONNULL_END
