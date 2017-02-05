//
//  TotalEntity.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/26/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappedEntity.h"

@interface TotalEntity : MappedEntity

@property (nonatomic, retain) NSString *code; // "sub_total"
@property (nonatomic, retain) NSString *title; // "Sub-Total"
@property (nonatomic, retain) NSString *text; // "$3,892.97"
@property (nonatomic, retain) NSNumber *value; // 3892.97
@property (nonatomic, retain) NSString *sort_order; // "1"

@end
