//
//  RemoteControlController.h
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/5/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCSharingPresenter.h"
#import "RCApplicationPresenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface RemoteControlController : UIViewController <RCApplicationPresenter, RCSharingPresenter>

@property (weak, nonatomic) IBOutlet UIImageView *remoteDisplay;

@end

NS_ASSUME_NONNULL_END
