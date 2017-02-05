//
//  ShippingMethodEntity.m
//  opencart
//
//  Created by Firuz Narzikulov on 5/12/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "ShippingMethodEntity.h"

@implementation ShippingMethodEntity

- (NSDictionary *)attributesKeyMap {
    return @{@"{type}.quote.{type}.code" : @"code",
             @"{type}.quote.{type}.title" : @"title",
             @"{type}.quote.{type}.cost" : @"cost",
             @"{type}.quote.{type}.tax_class_id" : @"tax_class_id",
             @"{type}.quote.{type}.text" : @"text",
             @"{type}.quote.{type}.sort_order" : @"sort_order"};
}

- (NSString *)nestedArbitraryKey {
    return @"type";
}

- (NSString *)screenName {
    return self.title;
}

@end
