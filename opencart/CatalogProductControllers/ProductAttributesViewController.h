//
//  ProductAttributesViewController.h
//  opencart
//
//  Created by Firuz Narzikulov on 19/12/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductEntity.h"


@interface ProductAttributesViewController : UITableViewController

@property (nonatomic, strong) NSArray *sortedShownNotEmptyArrayKeys;
@property (nonatomic, strong) ProductEntity *product;

@end
