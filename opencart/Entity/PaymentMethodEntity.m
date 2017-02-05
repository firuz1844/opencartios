//
//  PaymentMethodEntity.m
//  opencart
//
//  Created by Firuz Narzikulov on 02.08.16.
//  Copyright © 2016 ServiceTrade LLC. All rights reserved.
//

#import "PaymentMethodEntity.h"

@implementation PaymentMethodEntity

- (NSDictionary *)attributesKeyMap {
    return @{@"{type}.code" : @"code",
             @"{type}.title" : @"title",
             @"{type}.terms" : @"terms",
             @"{type}.sort_order" : @"sort_order"};
}

- (NSString *)nestedArbitraryKey {
    return @"type";
}

- (NSString *)screenName {
    return self.title;
}

@end
