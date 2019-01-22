//
//  SSLSocketHandler+Propected.h
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/15/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#ifndef SSLSocketHandler_Propected_h
#define SSLSocketHandler_Propected_h

#include "BSDSocketHandler.h"

@interface SSLSocketHandler ()

@property (unsafe_unretained, nonatomic) BSDSocketHandler *handler;

- (instancetype)initWithBSDSocketHandler:(BSDSocketHandler *)handler;

@end

#endif /* SSLSocketHandler_Propected_h */
