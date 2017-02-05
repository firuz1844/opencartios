//
//  TotalEntity.m
//  opencart
//
//  Created by Firuz Narzikulov on 4/26/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "TotalEntity.h"

@implementation TotalEntity

- (NSDictionary *)attributesKeyMap {
    return @{
             @"code":@"code",
             @"title":@"title",
             @"text":@"text",
             @"value":@"value",
             @"sort_order":@"sort_order",
             };
}
@end
