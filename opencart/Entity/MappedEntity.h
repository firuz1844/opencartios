//
//  MappedEntity.h
//  opencart
//
//  Created by Firuz Narzikulov on 04.06.16.
//  Copyright © 2016 ServiceTrade LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MappedEntity : NSObject

@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) id error;

- (NSDictionary*)attributesKeyMap;
- (NSString*)nestedArbitraryKey;
- (NSDictionary*)children;
- (NSString*)errorMessage;

// Returns dictionary of all non empty properties of self with values

- (NSDictionary*)propertiesAndValues;
- (NSDictionary*)jsonDictionary;

@end
