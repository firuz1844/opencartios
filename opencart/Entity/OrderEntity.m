//
//  OrderEntity.m
//  opencart
//
//  Created by Firuz Narzikulov on 06.06.16.
//  Copyright © 2016 ServiceTrade LLC. All rights reserved.
//

#import "OrderEntity.h"

@implementation OrderEntity

- (NSString*)orderText {
    // Order #30 - 3 products, total: $349.00
    return [NSString stringWithFormat:@"%@ #%@ - %@ %@, %@: %@%@", NSLocalizedString(@"Order", nil), self.order_id, self.products, NSLocalizedString(@"products", nil), self.currency_code, self.currency_value, NSLocalizedString(@"total", nil)];
}

- (NSString*)orderDetailText {
    // 05 June 2016, Customer: John Snow
    return [NSString stringWithFormat:@"%@, %@: %@", self.date_added, NSLocalizedString(@"Customer", nil), self.name];
}

@end
