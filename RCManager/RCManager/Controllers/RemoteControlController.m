//
//  RemoteControlController.m
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/5/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "RCManager.h"
#import "RCSocketDelegate.h"
#import <SSLSockets/SSLSockets.h>
#import "RCSocketSharingHandler.h"
#import "RemoteControlController.h"

@interface RemoteControlController ()

@property (strong, nonatomic) ClientApplication *clientApplication;
@property (strong, nonatomic) SSLServerSocket *screenSharingSocket;
@property (strong, nonatomic) NSMutableArray *touches;

@end



@implementation RemoteControlController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareViewController];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self prepareRemoteDisplay];
}

#pragma mark - Methods
- (void)prepareViewController {
    if (self.clientApplication) {
        int port = [self runSharingSocket];
        self.touches = [[NSMutableArray alloc] init];
        [self.clientApplication shareScreenToPort:port];
    }
}

- (void)prepareRemoteDisplay {
    if (!self.clientApplication) return;
    
    CGSize containerSize;
    if (@available(iOS 11, *)) {
        containerSize = self.view.safeAreaLayoutGuide.layoutFrame.size;
    } else {
        containerSize = self.view.bounds.size;
    }
    CGSize screenSize = self.clientApplication.screenSize;
    CGFloat containerAspectRatio = containerSize.width/containerSize.height;
    CGFloat screenAspectRatio = screenSize.width / screenSize.height;

    if (containerAspectRatio > screenAspectRatio) {
        self.remoteDisplayHeight.constant = containerSize.height;
        self.remoteDisplayWidth.constant = self.remoteDisplayHeight.constant * screenAspectRatio;
    } else {
        self.remoteDisplayWidth.constant = containerSize.width;
        self.remoteDisplayHeight.constant = self.remoteDisplayWidth.constant / screenAspectRatio;
    }
}

- (int)runSharingSocket {
    int port;
    RCSocketSharingHandler *handler = [[RCSocketSharingHandler alloc] initWithPresenter:self];
    RCSocketDelegate *delegate = [[RCSocketDelegate alloc] initWithHandler:handler];
    
    do {
        port = 1+ arc4random_uniform(65534);
        self.screenSharingSocket = [[SSLServerSocket alloc] initWithPort:port andDelegate:delegate];
        [self.screenSharingSocket startSocket];
    } while (![self.screenSharingSocket isRunning]);
    
    [[RCManager sharedInstance] receiveSharingFromSocket:self.screenSharingSocket];
    return port;
}

#pragma mark - Touches handling
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesPerformed:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesPerformed:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesPerformed:touches];
    [self redirectGesture];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.touches removeAllObjects];
}

- (void)touchesPerformed:(NSSet<UITouch *> *)touches {
    UITouch *touch = [touches anyObject];
    if (touch.view == self.remoteDisplay) {
        CGPoint touchLocation = [touch locationInView:self.remoteDisplay];
        [self.touches addObject:[NSValue valueWithCGPoint:touchLocation]];
    }
}

- (void)redirectGesture {
    if (![self.touches count]) return;
    NSArray *touches = [NSArray arrayWithArray:self.touches];
    [self.touches removeAllObjects];
    CGSize remoteDisplaySize = self.remoteDisplay.bounds.size;
    CGSize clientDisplaySize = self.clientApplication.screenSize;
    
    __block RemoteControlController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *gesture = [[NSMutableArray alloc] init];
        for (NSValue *touch in touches) {
            CGPoint touchLocation = [touch CGPointValue];
            CGFloat x = clientDisplaySize.width * touchLocation.x / remoteDisplaySize.width;
            CGFloat y = clientDisplaySize.height * touchLocation.y / remoteDisplaySize.height;
            NSDictionary *point = @{ @"x": [NSNumber numberWithFloat:x], @"y": [NSNumber numberWithFloat:y] };
            [gesture addObject:point];
        }
        [weakSelf.clientApplication executeGesture:gesture];
    });
}

#pragma mark - <RCSharingPresenter>
- (void)updateWithImage:(UIImage *)image {
    [self.remoteDisplay setImage:image];
}

#pragma mark - <RCApplicationPresenter>
- (void)setApplication:(ClientApplication *)application {
    self.clientApplication = application;
}

#pragma mark - Destructor
- (void)dealloc {
    [self.clientApplication stopSharingScreen];
}

@end
