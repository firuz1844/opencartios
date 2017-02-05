//
//  OptionValueEntity.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/26/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappedEntity.h"
@class OptionEntity;

@interface OptionValueEntity : MappedEntity

@property (nonatomic, weak) OptionEntity *parent;
@property (nonatomic, strong) NSString *image; // url or null
@property (nonatomic, strong) NSNumber *price; // "4.00"
@property (nonatomic, strong) NSString *price_prefix; // "+"
@property (nonatomic, strong) NSString *product_option_value_id; // "4"
@property (nonatomic, strong) NSString *option_value_id; // "39"
@property (nonatomic, strong) NSString *name; // "Red"
@property (nonatomic, strong) NSString *value; // same thing like name "Red", used in parsing cart
@property (nonatomic, strong) NSNumber *quantity;
@property (nonatomic, strong) NSString *price_formated; //"$4.00"

- (NSDictionary *)convertToDictionary;
- (NSString *) print;

@end
