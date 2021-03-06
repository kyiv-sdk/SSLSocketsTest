//
//  RCSocketSharingHandler.m
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/5/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "ProjectConstants.h"
#import "RCSocketSharingHandler.h"

@interface RCSocketSharingHandler ()

@property (weak, nonatomic) id<RCApplicationPresenter> presenter;
@property (strong, nonatomic) dispatch_queue_t serialThread;

@end



@implementation RCSocketSharingHandler

#pragma mark - Methods
- (void)handleBase64Image:(NSString *)base64Image {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64Image options:0];
    __block UIImage *screenshot = [UIImage imageWithData:data];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.presenter updateDisplayWithImage:screenshot];
    });
}

#pragma mark - <RCSocketHandler>
- (void)handleJSON:(NSDictionary *)json fromClient:(SSL *)client {
    dispatch_async(self.serialThread, ^{
        NSString *action = [json objectForKey:kRCActionKey];
        if ([action isEqualToString:kRCActionStartScreenSharing]) {
            NSString *imageString = [json objectForKey:kRCScreenshotKey];
            if (imageString) return [self handleBase64Image:imageString];
        }
        NSLog(@"RCSocketSharingHandler received non-sharing json");
    });
}

#pragma mark - Constructor
- (instancetype)initWithPresenter:(id<RCApplicationPresenter>)presenter {
    self = [super init];
    if (self) {
        self.presenter = presenter;
        self.serialThread = dispatch_queue_create("com.o9e6y.RCSocketSharingHandler", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

@end
