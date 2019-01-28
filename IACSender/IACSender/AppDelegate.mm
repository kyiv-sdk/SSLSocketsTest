//
//  AppDelegate.m
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/8/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "AppDelegate.h"
#import "NetworkManager.h"
#import "ProjectConstants.h"
#import <SSLSockets/SSLSockets.h>
#import "ReceivedTableViewController.h"

@interface AppDelegate ()

@property (weak, nonatomic) id <SocketConnectionDelegate> connectionDelegate;

@end



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SSLSocketsManager setLoggingInFileWithName:SSLLoggerFileName andMinimalPriority:SSLLoggingPriorityLog];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [SSLSocketsManager stopLogging];
    [self saveContext];
}


#pragma mark - Inter-App Communication
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    NSString *host = [url host];
    if ([host isEqualToString:OpenedSocketCallback]) {
        int port = [[url port] intValue];
        [self.connectionDelegate didOpenSocketWithPort:port];
        self.connectionDelegate = nil;
    } else if ([host isEqualToString:OpenSocketRequest]) {
        [SSLSocketsManager configureCertificatesWithCountry:@"UA"
                                                      state:@"Kyiv"
                                                   location:@"Kyiv"
                                               organization:@"SoftServe"
                                           organizationUnit:@"IACSender"
                                                 commonName:@"com.softserve.iacsender"
                                               emailAddress:@"ohord2@softserveinc.com"];
        
        ReceivedTableViewController *viewController = [self getReceivedTableViewControllerInstance];
        int port = [viewController openServerSocket];
        [[NetworkManager sharedManager] shareSocketConnectionWithPort:port toScheme:AnotherAppScheme withHost:OpenedSocketCallback];
    }
    
    return YES;
}


- (void)setSocketConnectionDelegate:(id<SocketConnectionDelegate>)delegate {
    self.connectionDelegate = delegate;
}


- (ReceivedTableViewController *)getReceivedTableViewControllerInstance {
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    NSArray<__kindof UIViewController *> *viewControllers = navigationController.viewControllers;
    for (int i = 0; i < viewControllers.count; i++) {
        if ([viewControllers[i] isKindOfClass:[ReceivedTableViewController class]]) {
            return (ReceivedTableViewController *)viewControllers[i];
        }
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ReceivedTableViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ReceivedTableViewController"];
    [navigationController pushViewController:viewController animated:true];
    return viewController;
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"IACSender"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
