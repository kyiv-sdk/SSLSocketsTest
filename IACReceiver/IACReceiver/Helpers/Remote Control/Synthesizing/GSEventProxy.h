//
//  GSEventProxy.h
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/11/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSEventProxy : NSObject {
@public
    unsigned int flags;
    unsigned int type;
    unsigned int ignored1;
    float x1;
    float y1;
    float x2;
    float y2;
    unsigned int ignored2[10];
    unsigned int ignored3[7];
    float sizeX;
    float sizeY;
    float x3;
    float y3;
    unsigned int ignored4[3];
}
@end

NS_ASSUME_NONNULL_END
