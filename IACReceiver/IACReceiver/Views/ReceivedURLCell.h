//
//  ReceivedURLCell.h
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/8/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReceivedURLCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *webPageNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *webPageURLLabel;

@end

NS_ASSUME_NONNULL_END
