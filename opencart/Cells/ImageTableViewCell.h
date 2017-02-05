//
//  ImageTableViewCell.h
//  opencart
//
//  Created by Firuz Narzikulov on 4/22/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *customImageView;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
