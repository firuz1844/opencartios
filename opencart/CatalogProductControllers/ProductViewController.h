//
//  ProductViewController.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/22/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductEntity.h"
#import "ProductQuantitySelectorViewController.h"


@interface ProductViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ProductQuantitySelectorDelegate>

@property (nonatomic, retain) ProductEntity *product;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *quantitySelectorView;
@property (weak, nonatomic) IBOutlet UITableView *quantitySelectorTableView;
@property (weak, nonatomic) IBOutlet UIView *starRatingFrame;


- (IBAction)addToCart:(id)sender;
- (IBAction)addOneToCart:(UIButton *)sender;
- (IBAction)buyNow:(UIButton *)sender;
- (IBAction)callToSeller:(id)sender;


@end
