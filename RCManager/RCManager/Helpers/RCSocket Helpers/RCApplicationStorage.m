//
//  RCApplicationStorage.m
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/1/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "RCApplicationStorage.h"

@interface RCApplicationStorage ()

@property (strong, nonatomic) NSMutableSet<ClientApplication *> *__applications;

@end



@implementation RCApplicationStorage

#pragma mark - Getters
- (NSSet<ClientApplication *> *)applications {
    return [NSSet setWithObject:[___applications allObjects]];
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
- (void)addClientApplication:(ClientApplication *)application {
    if (![self.applications containsObject:application]) {
        [self.__applications addObject:application];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.presenter didConnectApplication:application atIndex:[self activeClientsCount] -1];
        });
    }
}

- (ClientApplication *)removeApplicationWithIdentifier:(NSString *)identifier {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier like %@", identifier];
    NSSet *result = [self.__applications filteredSetUsingPredicate:predicate];
    ClientApplication *app = [result anyObject];
    NSUInteger index = [self.__applications indexOfAccessibilityElement:app];
    if (index != NSNotFound) {
        [self.__applications removeObject:app];
        [self.presenter didDisconnectApplication:app atIndex:index];
        return app;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.presenter updateApplicationsList];
    });
    return nil;
}

- (ClientApplication *)getApplicationWithIdentifier:(NSString *)identifier {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier like %@", identifier];
    NSSet *result = [self.__applications filteredSetUsingPredicate:predicate];
    return [result anyObject];
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
        self.__applications = [[NSMutableSet alloc] init];
    }
    return self;
}

@end
