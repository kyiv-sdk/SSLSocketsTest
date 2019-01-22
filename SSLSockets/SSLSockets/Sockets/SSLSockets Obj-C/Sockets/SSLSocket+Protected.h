//
//  SSLSocket+Protected.h
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/11/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#ifndef SSLSocket_Protected_h
#define SSLSocket_Protected_h

#import "BSDSocket.h"

@interface SSLSocket ()

@property (unsafe_unretained, nonatomic) BSDSocket *socket;

@end

#endif /* SSLSocket_Protected_h */
