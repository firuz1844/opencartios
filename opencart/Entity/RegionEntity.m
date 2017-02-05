//
//  RegionEntity.m
//  opencart
//
//  Created by Firuz Narzikulov on 5/17/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "RegionEntity.h"

@implementation RegionEntity

- (NSDictionary *)attributesKeyMap {
    return @{@"zone_id":@"zone_id",
             @"country_id":@"country_id",
             @"name":@"name",
             @"status":@"status",
             @"code":@"code",
             @"zone":@"zone",
             @"zone_code":@"zone_code"};
}

- (NSString *)name {
    if (_name) {
        return _name;
    }
    return _zone;
}

- (NSString *)code {
    if (_code) {
        return _code;
    }
    return _zone_code;
}

@end
