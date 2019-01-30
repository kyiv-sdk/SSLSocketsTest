//
//  SSLSocketsManager.h
//  SSLBSDSockets
//
//  Created by Oleksandr Hordiienko on 1/17/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "SSLLoggable.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSLSocketsManager : NSObject

/**
    @brief Creates certificates for SSLServerSocket's context signing with given info.
 */
+ (void)configureCertificatesWithCountry:(NSString *)country
                                  state:(NSString *)state
                               location:(NSString *)location
                           organization:(NSString *)organization
                       organizationUnit:(NSString *)organizationUnit
                             commonName:(NSString *)commonName
                           emailAddress:(NSString *)emailAddress;

@end

NS_ASSUME_NONNULL_END
