//
//  ScreenshotsManager.h
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/11/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScreenshotsManager : NSObject

- (void)startSessionWithWindow;
- (void)startSessionWithView:(UIView *)view;
- (UIImage * _Nullable)takeScreenshot;
- (void)endSession;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
