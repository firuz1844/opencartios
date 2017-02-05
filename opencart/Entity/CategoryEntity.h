//
//  Category.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/15/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappedEntity.h"


@interface CategoryEntity : MappedEntity

@property (nonatomic, retain) NSString *category_id;
@property (nonatomic, retain) NSString *parent_id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *image;
@property (nonatomic, retain) NSString *href;

@end
