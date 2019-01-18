//
//  URLSocketDelegate.m
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/17/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "CoreDataManager.h"
#import "ProjectConstants.h"
#import "URLSocketDelegate.h"
#import "WebSite+CoreDataProperties.h"

@implementation URLSocketDelegate

- (void)didReceiveMessage:(NSString *)message fromSSL:(SSL *)ssl {
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (json) {
        NSString *url = [json objectForKey:URLKey];
        if (url) {
            dispatch_async(dispatch_get_main_queue(), ^{
                WebSite *webSite = [[CoreDataManager sharedManager] addNewWebSiteWithURL:url];
                [self.webSiteHandler didReceiveWebSite:webSite];
            });
        }
    }
}



- (instancetype)initWithWebSiteHandler:(id<ReceivedWebSiteHandler>)handler {
    self = [super init];
    if (self) {
        self.webSiteHandler = handler;
    }
    return self;
}

@end
