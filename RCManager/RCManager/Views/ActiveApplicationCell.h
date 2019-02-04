//
//  ActiveApplicationCell.h
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/4/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActiveApplicationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *applicationName;
@property (weak, nonatomic) IBOutlet UILabel *applicationBundleId;
@property (weak, nonatomic) IBOutlet UILabel *applicationDeviceId;

@end

NS_ASSUME_NONNULL_END
