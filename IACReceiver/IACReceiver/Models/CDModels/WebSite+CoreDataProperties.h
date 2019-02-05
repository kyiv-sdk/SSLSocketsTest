//
//  WebSite+CoreDataProperties.h
//  IAReceiver
//
//  Created by Oleksandr Hordiienko on 2/5/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//
//

#import "WebSite+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WebSite (CoreDataProperties)

+ (NSFetchRequest<WebSite *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
