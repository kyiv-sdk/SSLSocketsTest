//
//  CoreDataManager.m
//  RCManager
//
//  Created by Oleksandr Hordiienko on 2/1/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataManager.h"
#import "ProjectConstants.h"

@interface CoreDataManager ()

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation CoreDataManager

#pragma mark - Getters
- (NSEntityDescription *)clienApplicationEntityDescription {
    return [NSEntityDescription entityForName:@"ClientApplication" inManagedObjectContext:self.context];
}


#pragma mark - Methods
- (void)saveChanges {
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) saveContext];
}

- (void)executeRequest:(NSFetchRequest *)request completion:(void (^)(NSArray * _Nullable results))handler {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error = nil;
        NSArray *results = [self.context executeFetchRequest:request error:&error];
        if (error) {
            NSLog(@"CD getApplicationWithIdentifier error: %@", error.localizedDescription);
            handler(nil);
        } else {
            handler(results);
        }
    });
}

- (void)getApplicationWithInfo:(NSDictionary *)info completion:(void (^)(ClientApplication * _Nonnull))handler {
    NSString *appName = [info valueForKey:kRCAppNameKey];
    NSString *bundleId = [info valueForKey:kRCAppBundleID];
    NSString *deviceId = [info valueForKey:kRCDeviceID];
    
    NSEntityDescription *clientAppEntityDescription = [self clienApplicationEntityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bundleID == %@ AND deviceID == %@", bundleId, deviceId];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:clientAppEntityDescription];
    [request setPredicate:predicate];
    
    [self executeRequest:request completion:^(NSArray * _Nullable results) {
        ClientApplication *app = [results firstObject];
        if (!app) {
            NSLog(@"Creating new app");
            app = [[ClientApplication alloc] initWithEntity:clientAppEntityDescription insertIntoManagedObjectContext:self.context];
            [app setName:appName];
            [app setBundleID:bundleId];
            [app setDeviceID:deviceId];
        }
        [self updateLastConnectionForApplication:app];
        handler(app);
    }];
}

- (void)updateLastConnectionForApplication:(ClientApplication *)application {
    [application setLastConnection:[NSDate date]];
    [self saveChanges];
}

#pragma mark - Singletone
+ (instancetype)sharedInstance {
    static id _sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CoreDataManager alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
            dispatch_group_leave(group);
        });
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    }
    return self;
}

@end
