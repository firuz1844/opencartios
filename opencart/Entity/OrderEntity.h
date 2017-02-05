//
//  OrderEntity.h
//  opencart
//
//  Created by Firuz Narzikulov on 06.06.16.
//  Copyright © 2016 ServiceTrade LLC. All rights reserved.
//

#import "MappedEntity.h"

@interface OrderEntity : MappedEntity

@property (nonatomic, strong) NSNumber *order_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSDate *date_added; //"07/04/2016"
@property (nonatomic, strong) NSNumber *products;
@property (nonatomic, strong) NSString *total; //"$111.00"
@property (nonatomic, strong) NSString *currency_code; // "USD"
@property (nonatomic, strong) NSNumber *currency_value; //"1.00000000"

- (NSString*)orderText;
- (NSString*)orderDetailText;

@end
