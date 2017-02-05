//
//  CountryEntity.m
//  opencart
//
//  Created by Firuz Narzikulov on 5/17/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "CountryEntity.h"

@implementation CountryEntity

- (NSDictionary *)attributesKeyMap {
    
    return @{@"country_id":@"country_id",
             @"name":@"name",
             @"iso_code_2":@"iso_code_2",
             @"iso_code_3":@"iso_code_3",
             @"address_format":@"address_format",
             @"postcode_required":@"postcode_required",
             @"status":@"status",
             @"country":@"country"};
}

- (NSString *)name {
    if (_name) {
        return _name;
    }
    return _country;
}

@end
