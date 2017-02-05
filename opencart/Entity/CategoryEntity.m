//
//  Category.m
//  opencart
//
//  Created by Firuz Narzikulov on 4/15/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "CategoryEntity.h"

@implementation CategoryEntity

- (NSDictionary *)attributesKeyMap {
    return @{@"category_id":@"category_id",
             @"parent_id":@"parent_id",
             @"name":@"name",
             @"image":@"image",
             @"href":@"href",
             };
}
@end
