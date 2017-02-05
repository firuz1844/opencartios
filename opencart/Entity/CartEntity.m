//
//  Cart.m
//  opencart
//
//  Created by Firuz Narzikulov on 4/15/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "CartEntity.h"

@implementation CartEntity

- (NSDictionary *)attributesKeyMap {
    return @{
             @"error_warning":@"error_warning",
             @"attention":@"attention",
             @"success":@"success",
             @"action":@"action",
             @"weight":@"weight",
             @"vouchers":@"vouchers",
             @"next":@"next",
             @"coupon_status":@"coupon_status",
             @"coupon":@"coupon",
             @"voucher_status":@"voucher_status",
             @"voucher":@"voucher",
             @"reward_status":@"reward_status",
             @"reward":@"reward",
             @"shipping_status":@"shipping_status",
             @"country_id":@"country_id",
             @"zone_id":@"zone_id",
             @"postcode":@"postcode",
             @"shipping_method":@"shipping_method",
             };
}

- (NSDictionary*)children {
    return @{
             @"totals->totals":[TotalEntity new],
             @"products->products":[ProductEntity new],
             };
}

@end
