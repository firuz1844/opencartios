//
//  OptionValueEntity.m
//  opencart
//
//  Created by Firuz Narzikulov on 4/26/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "OptionValueEntity.h"
#import "OptionEntity.h"

@implementation OptionValueEntity

- (NSDictionary *)attributesKeyMap {
    return @{
             @"image":@"image",
             @"price":@"price",
             @"price_prefix":@"price_prefix",
             @"product_option_value_id":@"product_option_value_id",
             @"option_value_id":@"option_value_id",
             @"name":@"name",
             @"value":@"value",
             @"quantity":@"quantity",
             @"price_formated":@"price_formated"
             };
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
}

- (NSDictionary *)convertToDictionary {
    //build an info object and convert to json
    NSMutableDictionary* info = [NSMutableDictionary new];
    if ([self.parent.type isEqualToString:@"select"] || [self.parent.type isEqualToString:@"radio"]) {
        [info setObject:self.product_option_value_id forKey:self.parent.product_option_id];
    }
//    if ([self.parent.type isEqualToString:@"checkbox"]) {
//        for (NSString *optValue in ) {
//            <#statements#>
//        }
//    }

    return info;
}

- (void)setValue:(NSString *)value {
    _value = value;
}

- (NSString *) print {
    NSString *string = [NSString stringWithFormat:@"%@: %@", self.name, self.value];
    return string;
}

@end
