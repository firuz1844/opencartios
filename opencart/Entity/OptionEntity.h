//
//  OptionEntity.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/26/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappedEntity.h"
@class OptionValueEntity;

@interface OptionEntity : MappedEntity

//Detailed Product properties
@property (nonatomic, retain) NSString *type; // select, radio, checkbox
@property (nonatomic, retain) NSArray <OptionValueEntity*> *option_value;
@property (nonatomic, retain) NSNumber *required; // 1/0
@property (nonatomic, retain) NSString *product_option_id; // "217"
@property (nonatomic, retain) NSString *option_id; // "5"

//Cart product option properties
@property (nonatomic, retain) NSString *name; // "Size"
@property (nonatomic, retain) NSString *value; // "Blue"


@end
