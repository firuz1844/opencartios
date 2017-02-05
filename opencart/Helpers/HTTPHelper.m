//
//  HTTPHelper.m
//  opencart
//
//  Created by Firuz Narzikulov on 4/23/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "HTTPHelper.h"

@implementation HTTPHelper

+ (NSString*)prepareStringForURL:(NSString *)unescapedString {
    
    NSString *charactersToEscape = @"!*'();:@&=+$,/?%#[]\" ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedString = [unescapedString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return encodedString;
}

@end
