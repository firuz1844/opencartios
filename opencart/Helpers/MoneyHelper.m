//
//  MoneyHelper.m
//  opencart
//
//  Created by Firuz Narzikulov on 4/16/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "MoneyHelper.h"
#import "Configurator.h"

@implementation MoneyHelper

+(NSNumber *) getNumberFromPriceString: (NSString *) priceString {
    float priceValue = [[priceString stringByTrimmingCharactersInSet:[NSCharacterSet symbolCharacterSet]] floatValue];
    return [NSNumber numberWithFloat:priceValue];
}
+(NSString *) getCurrencyFropPriceString: (NSString *) priceString {
//    NSString *currency = [priceString stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
//    currency = [currency stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [currency length])];
    return [Configurator getDefaultCurrency];
}

+(NSString *) getFormattedPrice: (float) priceValue {
    NSLocale *locale = [NSLocale currentLocale];
    NSNumberFormatter *currencyStyle = [[NSNumberFormatter alloc] init];
    
    [currencyStyle setLocale:locale];
    [currencyStyle setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyStyle setCurrencySymbol:[Configurator getDefaultCurrency]];
    NSNumber *amount = [NSNumber numberWithDouble:priceValue];
    NSString *amountString =  [currencyStyle stringFromNumber:amount];
    
//    NSNumber *pAmount = [currencyStyle numberFromString:amountString]; // == 1256.34
    return amountString;
}

@end
