//
//  TotalForCartTableViewCell.h
//  opencart
//
//  Created by Firuz Narzikulov on 5/17/14.
//  Copyright (c) 2014 ServiceTrade LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TotalForCartTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *title; // "Sub-Total"
@property (nonatomic, retain) IBOutlet UILabel *text; // "$3,892.97"

@end
