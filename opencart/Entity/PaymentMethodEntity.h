//
//  PaymentMethodEntity.h
//  opencart
//
//  Created by Firuz Narzikulov on 02.08.16.
//  Copyright © 2016 ServiceTrade LLC. All rights reserved.
//

#import "MappedEntity.h"

@interface PaymentMethodEntity : MappedEntity

@property (nonatomic, retain) NSString *code;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *terms;
@property (nonatomic, retain) NSString *sort_order;

@property (nonatomic, retain) NSString *type;

- (NSString*)screenName;

@end
