//
//  Product.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/15/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappedEntity.h"
#import "OptionEntity.h"
#import "OptionValueEntity.h"


@interface ProductEntity : MappedEntity

#pragma mark Properties of product in catalod
@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSString *product_id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *descriptions;
@property (nonatomic, retain) NSString *href;

// Image used in catalog
@property (nonatomic, retain) NSURL *image; //small image

@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *special;
@property (nonatomic, retain) NSString *rating;

#pragma mark Detailed product properties
@property (nonatomic, retain) NSString *seo_h1;
@property (nonatomic, retain) NSString *manufacturer;
@property (nonatomic, retain) NSString *model;
@property (nonatomic, retain) NSArray *images;
@property (nonatomic, retain) NSArray *attribute_groups;
@property (nonatomic, retain) NSArray *discounts;
@property (nonatomic, retain) NSMutableArray<OptionEntity*> *options;
@property (nonatomic, retain) NSString *minimum;
@property (nonatomic, retain) NSString *reward;
@property (nonatomic, retain) NSString *points;
@property (nonatomic, retain) NSString *quantity;
@property (nonatomic, retain) NSString *sku;




#pragma mark Properties of product in shopping cart

@property (nonatomic, retain) NSString *key; // "49::"
// Image used in Cart
@property (nonatomic, retain) NSURL *thumb; //url string
@property (nonatomic, retain) NSMutableArray <OptionValueEntity*> *option;
//@property (nonatomic) NSNumber *quantity; // 3
@property  BOOL stock; // true-false
@property (nonatomic, retain) NSString *total;
@property (nonatomic, retain) NSString *remove; //url



#pragma mark JSON methods
- (NSData*) jsonForAddingToCartWithQuantity:(NSInteger) quantity;
- (NSData*) jsonForUpdateQuantityInCart:(NSInteger) quantity;
- (NSData*) jsonDeleteProductFromCart;

- (NSDictionary*)optionsDict;

@end
