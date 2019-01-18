//
//  SocketConnectionDelegate.h
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/17/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#ifndef SocketConnectionDelegate_h
#define SocketConnectionDelegate_h

@protocol SocketConnectionDelegate

- (void)didOpenSocketWithPort:(int)port;

@end

#endif /* SocketConnectionDelegate_h */
