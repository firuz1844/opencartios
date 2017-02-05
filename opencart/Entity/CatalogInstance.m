//
//  CatalogInstance.m
//  opencart
//
//  Created by Firuz Narzikulov on 4/25/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import "CatalogInstance.h"

@implementation CatalogInstance

+ (CatalogInstance *)sharedInstance
{
    static CatalogInstance *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
