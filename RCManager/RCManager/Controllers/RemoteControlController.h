//
//  RemoteControlController.h
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/5/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCApplicationPresenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface RemoteControlController : UIViewController <RCApplicationPresenter>

@property (weak, nonatomic) IBOutlet UIImageView *remoteDisplay;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remoteDisplayWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remoteDisplayHeight;


@end

NS_ASSUME_NONNULL_END
