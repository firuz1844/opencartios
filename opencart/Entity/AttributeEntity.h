//
//  AttributeEntity.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/26/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappedEntity.h"

@interface AttributeEntity : MappedEntity

@property (nonatomic, retain) NSString *attribute_id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *text;

//"attribute_id": "3"
//"name": "Clockspeed"
//"text": "100mhz"

@end
