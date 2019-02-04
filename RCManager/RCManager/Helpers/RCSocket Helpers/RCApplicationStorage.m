//
//  RCApplicationStorage.m
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/1/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "RCApplicationStorage.h"

@interface RCApplicationStorage ()

@property (strong, nonatomic) NSMutableArray<ClientApplication *> *__applications;

@end



@implementation RCApplicationStorage

#pragma mark - Getters
- (NSArray<ClientApplication *> *)applications {
    return [NSArray arrayWithArray: self.__applications];
}

- (NSUInteger)activeClientsCount {
    return ___applications.count;
}

#pragma mark - Setters
- (void)setPresenter:(id<RCApplicationsPresenter>)presenter {
    _presenter = presenter;
    [presenter updateApplicationsList];
}

#pragma mark - Methods
- (void)addApplication:(ClientApplication *)application {
    if (![self.applications containsObject:application]) {
        [self.__applications addObject:application];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.presenter didConnectApplication:application atIndex:[self activeClientsCount] -1];
        });
    }
}

- (void)removeApplication:(ClientApplication *)application {
    NSUInteger index = [self.__applications indexOfObject:application];
    if (index != NSNotFound) {
        [self.__applications removeObject:application];
        [self.presenter didDisconnectApplication:application atIndex:index];
    } else {
        [self.presenter updateApplicationsList];
    }
}

- (ClientApplication *)applicationAtIndex:(NSUInteger)index {
    return [self.__applications objectAtIndex:index];
}

#pragma mark - Singletone
+ (instancetype)sharedInstance {
    static id _sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[RCApplicationStorage alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.__applications = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
