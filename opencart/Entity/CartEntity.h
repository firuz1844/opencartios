//
//  Cart.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/15/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappedEntity.h"
#import "TotalEntity.h"
#import "ProductEntity.h"

@interface CartEntity : MappedEntity

@property (nonatomic, retain) NSString *error_warning;
@property (nonatomic, retain) NSString *attention;
//@property (nonatomic, retain) NSString *success;
@property (nonatomic, retain) NSString *action; // "[baseurl]/index.php?route=checkout/cart"
@property (nonatomic, retain) NSString *weight; // "36.50kg"
@property (nonatomic, retain) NSMutableArray *products;
@property (nonatomic, retain) NSArray *vouchers;
@property (nonatomic, retain) NSString *next;
@property (nonatomic, retain) NSString *coupon_status;
@property (nonatomic, retain) NSString *coupon;
@property (nonatomic, retain) NSString *voucher_status;
@property (nonatomic, retain) NSString *voucher;
@property (nonatomic) BOOL reward_status;
@property (nonatomic, retain) NSString *reward;
@property (nonatomic) BOOL shipping_status;
@property (nonatomic, retain) NSString *country_id;
@property (nonatomic, retain) NSString *zone_id;
@property (nonatomic, retain) NSString *postcode;
@property (nonatomic, retain) NSString *shipping_method; // "flat.flat"
@property (nonatomic, retain) NSArray <TotalEntity*> *totals;

@end
