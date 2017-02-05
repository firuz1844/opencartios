//
//  Address.m
//  opencart
//
//  Created by Firuz Narzikulov on 4/15/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "AddressEntity.h"

@implementation AddressEntity

- (NSDictionary *)attributesKeyMap {
    return @{@"address_id":@"address_id",
             @"city_id":@"city_id",
             @"area_id":@"area_id",
             @"warehouse_id":@"warehouse_id",
             @"firstname":@"firstname",
             @"lastname":@"lastname",
             @"company":@"company",
             @"address_1":@"address_1",
             @"address_2":@"address_2",
             @"postcode":@"postcode",
             @"city":@"city",
//             @"zone_id":@"zone_id",
//             @"zone":@"zone",
//             @"zone_code":@"zone_code",
//             @"country_id":@"country_id",
//             @"country":@"country",
//             @"iso_code_2":@"iso_code_2",
//             @"iso_code_3":@"iso_code_3",
//             @"address_format":@"address_format"
             };
}

- (NSDictionary *)children {
    return @{
             @"->country":[CountryEntity new],
             @"->region":[RegionEntity new]
             };

}

- (NSArray*)keysForPUT {
    return @[@"firstname",
             @"lastname",
             @"company",
             @"address_1",
             @"address_2",
             @"postcode",
             @"city",
             @"region.zone_id->zone_id", // the output value will be saved at "zone_id" key
             @"country.country_id->country_id"];
}

- (NSString *)screenName {
    return [NSString stringWithFormat:@"%@: %@ %@", self.city, self.firstname, self.lastname];
}

- (NSDictionary *)jsonForCheckoutBillingAddress {
    return @{
             @"payment_address": @"existing",
             @"address_id": self.address_id
             };
}

- (NSDictionary *)jsonForCheckoutShippingAddress {
    return @{
             @"shipping_address": @"existing",
             @"address_id": self.address_id
             };
}

@end
