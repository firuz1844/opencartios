//
//  BuyTableViewCell.h
//  opencart
//
//  Created by Firuz Narzikulov on 6/3/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
@property (strong, nonatomic) IBOutlet UIButton *btnBuyNow;
@property (strong, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *starRatingFrameView;

@end
