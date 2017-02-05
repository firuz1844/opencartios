//
//  RegionEntity.h
//  opencart
//
//  Created by Firuz Narzikulov on 5/17/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappedEntity.h"

@interface RegionEntity : MappedEntity

@property (nonatomic, strong) NSString *zone_id; //"1507",
@property (nonatomic, strong) NSString *country_id; // "100",
@property (nonatomic, strong) NSString *name; // "Aceh",
@property (nonatomic, assign, getter=isStatus) BOOL status; // "1",
@property (nonatomic, strong) NSString *code; // "AC"

@property (nonatomic, strong) NSString *zone;
@property (nonatomic, strong) NSString *zone_code;


@end
