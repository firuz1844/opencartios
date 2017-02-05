//
//  CatalogInstance.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/25/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatalogInstance : NSObject

+ (CatalogInstance *)sharedInstance;

@property (nonatomic, retain) NSArray *categories;
@property (nonatomic, retain) NSArray *products;

@end
