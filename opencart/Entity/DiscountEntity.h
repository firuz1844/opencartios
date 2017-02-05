//
//  DiscountEntity.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/26/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappedEntity.h"

@interface DiscountEntity : MappedEntity

@property (nonatomic, retain) NSString *quantity;
@property (nonatomic, retain) NSString *price;

//"quantity": "10",
//"price": "$88.00"

@end
