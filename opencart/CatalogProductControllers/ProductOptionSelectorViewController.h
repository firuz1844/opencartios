//
//  ProductOptionSelectorViewController.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/27/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionEntity.h"

@protocol ProductOptionSelectorDelegate

- (void)didSelectedOptions:(NSMutableArray *)options;

@end

@interface ProductOptionSelectorViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<ProductOptionSelectorDelegate> delegate;

@property (nonatomic, retain) OptionEntity *currentOption; //The option type which we should to choose
@property (nonatomic, retain) NSMutableArray *choosedByUserOptions; //the _product.option array where stores options selected by user

@end
