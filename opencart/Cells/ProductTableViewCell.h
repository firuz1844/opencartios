//
//  ProductTableViewCell.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/15/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *lableName;
@property (nonatomic, retain) IBOutlet UILabel *lablePrice;
@property (nonatomic, retain) IBOutlet UIImageView *image;

@end
