//
//  CoreDataManager.m
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/9/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//

#import "CoreDataManager.h"

@interface CoreDataManager ()

@property (strong, nonatomic, readonly) NSManagedObjectContext *context;

- (void)saveChanges;

@end



@implementation CoreDataManager

- (NSManagedObjectContext *)context {
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
}



- (void)saveChanges {
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) saveContext];
}


- (NSArray *)getWebSites {
    NSError *error = nil;
    NSFetchRequest *request = [WebSite fetchRequest];
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error fetching Employee objects: %@ -> %@", [error localizedDescription], [error userInfo]);
    }
    return results;
}


- (WebSite *)addNewWebSiteWithURL:(NSString *)url {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WebSite" inManagedObjectContext:self.context];
    WebSite *webSite = [[WebSite alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.context];
    webSite.date = [NSDate date];
    webSite.url = url;
    [self saveChanges];
    return webSite;
}


+ (instancetype)sharedManager {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoreDataManager alloc] init];
    });
    return sharedInstance;
}

@end
