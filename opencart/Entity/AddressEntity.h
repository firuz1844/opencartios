//
//  Address.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/15/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappedEntity.h"

#import "CountryEntity.h"
#import "RegionEntity.h"

@interface AddressEntity : MappedEntity

@property (nonatomic, strong) NSString *address_id; // "158",
@property (nonatomic, strong) NSString *city_id; // "0",
@property (nonatomic, strong) NSString *area_id; // "0",
@property (nonatomic, strong) NSString *warehouse_id; // "0",
@property (nonatomic, strong) NSString *firstname; // "Firuz",
@property (nonatomic, strong) NSString *lastname; // "Narzikulov",
@property (nonatomic, strong) NSString *company; // "My company name",
@property (nonatomic, strong) NSString *address_1; // "This is my first address",
@property (nonatomic, strong) NSString *address_2; //  "This is my second address",
@property (nonatomic, strong) NSString *postcode; // "115093",
@property (nonatomic, strong) NSString *city; // "Moscow",

@property (nonatomic, strong) CountryEntity *country;
@property (nonatomic, strong) RegionEntity *region;

//@property (nonatomic, strong) NSString *zone_id; // "2761",
//@property (nonatomic, strong) NSString *zone; // "Moscow",
//@property (nonatomic, strong) NSString *zone_code; // "MO",

//@property (nonatomic, strong) NSString *country_id; // "176",
//@property (nonatomic, strong) NSString *country; // "Russian Federation",

//@property (nonatomic, strong) NSString *iso_code_2; // "RU",
//@property (nonatomic, strong) NSString *iso_code_3; // "RUS",
//@property (nonatomic, strong) NSString *address_format; // "",

- (NSString*)screenName;

- (NSDictionary *)jsonForCheckoutBillingAddress;
- (NSDictionary *)jsonForCheckoutShippingAddress;


@end
