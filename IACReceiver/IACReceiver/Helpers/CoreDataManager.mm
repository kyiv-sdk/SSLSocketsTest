//
//  CoreDataManager.m
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/9/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "NetworkManager.h"
#import "CoreDataManager+Protected.h"

@interface CoreDataManager ()

@property (strong, nonatomic, readonly) NSManagedObjectContext *context;

- (void)saveChanges;

@end



@implementation CoreDataManager

#pragma mark - Getters
- (NSManagedObjectContext *)context {
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
}

- (void)saveChanges {
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) saveContext];
}

- (NSEntityDescription *)wipableEntities {
    return [NSEntityDescription entityForName:@"Wipable" inManagedObjectContext:self.context];
}

- (NSEntityDescription *)webSiteEntityDescription {
    return [NSEntityDescription entityForName:@"WebSite" inManagedObjectContext:self.context];
}

#pragma mark - Methods
- (NSArray *)getWebSites {
    NSError *error = nil;
    NSFetchRequest *request = [WebSite fetchRequest];
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error fetching WebSites objects: %@ -> %@", [error localizedDescription], [error userInfo]);
    }
    return results;
}

- (WebSite *)addNewWebSiteWithURL:(NSString *)url {
    WebSite *webSite = [[WebSite alloc] initWithEntity:[self webSiteEntityDescription] insertIntoManagedObjectContext:self.context];
    webSite.date = [NSDate date];
    webSite.url = url;
    [self saveChanges];
    return webSite;
}


- (void)setTitleForWebSite:(WebSite *)webSite comletionHandler:(void (^)())handler {
    NSURL *url = [NSURL URLWithString:webSite.url];
    if (url) {
        [[NetworkManager sharedManager] getTitleOfWebSiteWithURL:url completionHandler:^(NSString * _Nullable title) {
            [webSite setTitle:title];
            [self saveChanges];
            handler();
        }];
    } else {
        [webSite setTitle:@"Invalid URL"];
        [self saveChanges];
        handler();
    }
}

#pragma mark - Protected
- (void)wipeStorage {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self wipeTableWithEnitity:[self wipableEntities]];
        [self saveChanges];
    });
}

- (void)wipeTableWithEnitity:(NSEntityDescription *)entityDescription {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityDescription.name];
    request.returnsObjectsAsFaults = false;
    
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    if (!error) {
        for (NSManagedObject *object in results) {
            [self.context deleteObject:object];
        }
    } else {
        NSLog(@"Error fetching %@ objects: %@ -> %@", entityDescription.name, [error localizedDescription], [error userInfo]);
    }
}

#pragma mark - Singletone
+ (instancetype)sharedManager {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoreDataManager alloc] init];
    });
    return sharedInstance;
}

@end
