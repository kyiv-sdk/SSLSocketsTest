//
//  RCSharingPresenter.h
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/5/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RCSharingPresenter <NSObject>

- (void)updateWithImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
