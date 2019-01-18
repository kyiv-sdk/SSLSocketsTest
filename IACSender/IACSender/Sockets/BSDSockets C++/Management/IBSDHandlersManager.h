//
//  BSDHandlersManager.h
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/16/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#ifndef BSDHandlersManager_h
#define BSDHandlersManager_h

class BSDSocketHandler;

class IBSDHandlersManager {
    
public:
    virtual void didStopHandler(BSDSocketHandler *handler) = 0;
    
};

#endif /* BSDHandlersManager_h */
