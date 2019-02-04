//
//  WebSite+CoreDataProperties.h
//  IACSender
//
//  Created by Oleksandr Hordiienko on 1/17/19.
//  Copyright © 2019 SoftServe. All rights reserved.
//
//

#import "WebSite+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WebSite (CoreDataProperties)

+ (NSFetchRequest<WebSite *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSDate *date;

@end

NS_ASSUME_NONNULL_END
