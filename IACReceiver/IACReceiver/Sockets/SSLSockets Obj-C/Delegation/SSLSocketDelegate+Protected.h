//
//  SSLSocketDelegate+Protected.h
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/18/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#ifndef SSLSocketDelegate_Protected_h
#define SSLSocketDelegate_Protected_h

#import "BSDSocketDelegate.h"
#import "SSLSocketDelegate.h"

@interface SSLSocketDelegate ()

@property (unsafe_unretained, nonatomic) BSDSocketDelegate *cDelegate;

@end

#endif /* SSLSocketDelegate_Protected_h */
