//
//  MoneyHelper.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/16/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyHelper : NSObject

+(NSNumber *) getNumberFromPriceString: (NSString *) priceString;
+(NSString *) getCurrencyFropPriceString: (NSString *) priceString;
+(NSString *) getFormattedPrice: (float) priceValue;

@end
