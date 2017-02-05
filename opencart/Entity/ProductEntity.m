//
//  Product.m
//  opencart
//
//  Created by Firuz Narzikulov on 4/15/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "ProductEntity.h"
#import "HTTPHelper.h"
#import "OptionValueEntity.h"

@implementation ProductEntity

- (NSDictionary *)attributesKeyMap {
    return @{@"id":@"uid",
             @"product_id":@"product_id",
             @"name":@"name",
             @"descriptions":@"descriptions",
             @"href":@"href",
             @"image":@"image",
             @"price":@"price",
             @"special":@"special",
             @"rating":@"rating",
             @"seo_h1":@"seo_h1",
             @"manufacturer":@"manufacturer",
             @"model":@"model",
             @"images":@"images",
             @"attribute_groups":@"attribute_groups",
             @"discounts":@"discounts",
             @"minimum":@"minimum",
             @"reward":@"reward",
             @"points":@"points",
             @"quantity":@"quantity",
             @"sku":@"sku",
             @"key":@"key",
             @"thumb":@"thumb",
             @"stock":@"stock",
             @"total":@"total",
             @"remove":@"remove"
             };
}

- (NSDictionary *)children {
    return @{
             @"options->options":[OptionEntity new],
             @"option->option":[OptionValueEntity new]
             };
}

- (void)setUid:(NSString *)uid {
    _uid = uid;
    _product_id = uid;
}

- (void)setProduct_id:(NSString *)product_id {
    _product_id = product_id;
    _uid = product_id;
}

#pragma mark JSON methods
-(NSData*) jsonForAddingToCartWithQuantity:(NSInteger) quantity {
    
    NSError *error = nil;
    //prepare option array
    NSMutableDictionary *optionsDict = [NSMutableDictionary new];
    for (OptionValueEntity *optionValue in _option) {
        if ([optionValue.parent.type isEqualToString:@"checkbox"]) {
            NSMutableArray *currentOptionCheckBoxArray = [optionsDict objectForKey:optionValue.parent.product_option_id];
            if (!currentOptionCheckBoxArray) {
                [optionsDict setObject:[NSMutableArray new] forKey:optionValue.parent.product_option_id];
                currentOptionCheckBoxArray = [optionsDict objectForKey:optionValue.parent.product_option_id];
            }
            [currentOptionCheckBoxArray addObject:optionValue.product_option_value_id];

        } else {
            [optionsDict addEntriesFromDictionary: [optionValue convertToDictionary]];
        }
    }
    
    //build an info object and convert to json
    NSDictionary* info;
    if (optionsDict.count > 0) {
        info = @{@"product_id": self.uid,
                 @"quantity" : [NSString stringWithFormat:@"%ld", (long)quantity],
                 @"option" : optionsDict};
    } else {
        info = @{@"product_id": self.uid,
                 @"quantity" : [NSString stringWithFormat:@"%ld", (long)quantity]};
    }
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    NSString *encodedJSON = [[NSString alloc] initWithData:jsonData
                                             encoding:NSUTF8StringEncoding];

    NSLog(@"JSON to POST: %@", encodedJSON);
    NSData *data = [encodedJSON dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];

    return data;

}


- (NSData*) jsonForUpdateQuantityInCart:(NSInteger) quantity {
    NSError *error = nil;
    //build an info object and convert to json
    NSDictionary* obj = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSString stringWithFormat:@"%ld", (long)quantity], self.uid,
                          nil];
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                          obj, @"quantity"
                          , nil];
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    NSString *encodedJSON = [[NSString alloc] initWithData:jsonData
                                                  encoding:NSUTF8StringEncoding];
    
    NSLog(@"JSON to PUT: %@", encodedJSON);
    NSData *data = [encodedJSON dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    return data;
    
}

- (NSData*) jsonDeleteProductFromCart {
    NSError *error = nil;
    //build an info object and convert to json
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                          _key, @"product_id"
                          , nil];
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    NSString *encodedJSON = [[NSString alloc] initWithData:jsonData
                                                  encoding:NSUTF8StringEncoding];
    
    NSLog(@"JSON to DELETE: %@", encodedJSON);
    NSData *data = [encodedJSON dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    return data;
    
}

- (NSDictionary*)optionsDict {
    NSMutableDictionary *optionsDict = [NSMutableDictionary new];
    for (OptionValueEntity *optionValue in _option) {
        if ([optionValue.parent.type isEqualToString:@"checkbox"]) {
            NSMutableArray *currentOptionCheckBoxArray = [optionsDict objectForKey:optionValue.parent.product_option_id];
            if (!currentOptionCheckBoxArray) {
                [optionsDict setObject:[NSMutableArray new] forKey:optionValue.parent.product_option_id];
                currentOptionCheckBoxArray = [optionsDict objectForKey:optionValue.parent.product_option_id];
            }
            [currentOptionCheckBoxArray addObject:optionValue.product_option_value_id];
            
        } else {
            [optionsDict addEntriesFromDictionary: [optionValue convertToDictionary]];
        }
    }
    return optionsDict;
}


@end
