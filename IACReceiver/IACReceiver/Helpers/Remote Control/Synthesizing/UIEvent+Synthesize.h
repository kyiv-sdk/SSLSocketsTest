//
//  UIEvent+Synthesize.h
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/7/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GSEventProxy;

NS_ASSUME_NONNULL_BEGIN

@interface UIEvent (Synthesize)

- (id)_initWithEvent:(GSEventProxy *)fp8 touches:(id)fp12;
- (id)initWithTouch:(UITouch *)touch;

@end

NS_ASSUME_NONNULL_END
