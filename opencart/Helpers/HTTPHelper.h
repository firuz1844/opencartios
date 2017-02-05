//
//  HTTPHelper.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/23/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPHelper : NSObject

+ (NSString*)prepareStringForURL:(NSString *)unescapedString;

@end
