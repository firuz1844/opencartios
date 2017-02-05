//
//  ShippingMethodEntity.h
//  opencart
//
//  Created by Firuz Narzikulov on 5/12/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappedEntity.h"

@interface ShippingMethodEntity : MappedEntity

@property (nonatomic, retain) NSString *code;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *cost;
@property (nonatomic, retain) NSString *tax_class_id;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *sort_order;

@property (nonatomic, retain) NSString *type;

- (NSString*)screenName;

@end
