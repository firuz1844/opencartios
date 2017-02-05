//
//  ProductInCartTableViewCell.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/25/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductInCartTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *thumb;
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *options;


@end
