//
//  CountryEntity.h
//  opencart
//
//  Created by Firuz Narzikulov on 5/17/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappedEntity.h"

@interface CountryEntity : MappedEntity

@property (nonatomic, strong) NSString *name; // "Aaland Islands",
@property (nonatomic, strong) NSString *country; // "Aaland Islands",

@property (nonatomic, strong) NSString *country_id; // "244",

@property (nonatomic, strong) NSString *iso_code_2; // "AX",
@property (nonatomic, strong) NSString *iso_code_3; // "ALA",
@property (nonatomic, strong) NSString *address_format; // "",
@property (nonatomic, assign, getter=isPostcodeRequired) BOOL postcode_required; // "0",
@property (nonatomic, assign, getter=isStatus) BOOL status; // "1"


@end
