//
//  ProductQuantitySelectorViewController.h
//  opencart
//
//  Created by Firuz Narzikulov on 5/17/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

@protocol ProductQuantitySelectorDelegate <NSObject>

-(void)didSelectNumberToAdd:(NSInteger) quantity;

@end
#import <UIKit/UIKit.h>

@interface ProductQuantitySelectorViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) id <ProductQuantitySelectorDelegate> delegate;

@end
