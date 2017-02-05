//
//  PropertyUtil.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/26/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyUtil : NSObject

+ (NSDictionary *)classPropsFor:(Class)klass;
+(NSDictionary *) getPropertiesForRemoteImageWithUrlString: (NSString *) imageURLString;


@end