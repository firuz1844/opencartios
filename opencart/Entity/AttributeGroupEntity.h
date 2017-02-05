//
//  AttributeGroupEntity.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/26/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappedEntity.h"

@interface AttributeGroupEntity : MappedEntity

@property (nonatomic, retain) NSString *attribute_group_id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) id attribute;

//"attribute_group_id": "6"
//"name": "Processor"
//"attribute": []

@end
