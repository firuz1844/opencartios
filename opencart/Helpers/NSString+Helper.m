//
//  NSString+Helper.m
//  opencart
//
//  Created by Firuz Narzikulov on 16/12/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

-(NSString *) stringByStrippingHTML {
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    
    s = [s stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    s = [s stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    
    return s;
}

@end
